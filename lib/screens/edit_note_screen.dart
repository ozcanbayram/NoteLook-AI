import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/models/note.dart';
import 'package:note_ai/product/custom_widgets.dart';
import 'package:note_ai/product/project_colors.dart';
import 'package:note_ai/product/project_texts.dart';
import 'package:note_ai/services/ai_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  // ignore: use_key_in_widget_constructors
  const EditNoteScreen({required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  bool _isImprovedVisible = false;
  String _improvedContent = "";

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    String newTitle = _titleController.text.trim();
    String newContent = _contentController.text.trim();

    if (newTitle.isNotEmpty && newContent.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          CollectionReference notes =
              FirebaseFirestore.instance.collection('notes');
          await notes.doc(widget.note.id).update({
            'title': newTitle,
            'content': newContent,
          });
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } catch (e) {
        // ignore: avoid_print
        print('Hata oluştu: $e'); //Hatayı görmek için
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().alertAddNote)),
      );
    }
  }

  Future<void> _summarizeNote() async {
    setState(() {
      _isLoading = true;
    });

    String? summary = await getGeminiData(_contentController.text);
    if (summary != null) {
      setState(() {
        _contentController.text = summary;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().summarizingError)),
      );
    }
  }

  Future<void> _improveNote() async {
    setState(() {
      _isLoading = true;
    });

    String? improved = await improveText(_contentController.text);
    if (improved != null) {
      setState(() {
        _improvedContent = improved;
        _isLoading = false;
        _isImprovedVisible = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isImprovedVisible = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().developeNoteError)),
      );
    }
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ProjectTexts().deleteNote),
          content: Text(ProjectTexts().deleteNoteAlert),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(ProjectTexts().no),
            ),
            TextButton(
              onPressed: () async {
                try {
                  CollectionReference notes =
                      FirebaseFirestore.instance.collection('notes');
                  await notes.doc(widget.note.id).delete();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                } catch (e) {
                  // ignore: avoid_print
                  print('Hata oluştu: $e');
                }
              },
              child: Text(ProjectTexts().yes),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fixErrors() async {
    setState(() {
      _isLoading = true;
    });

    String? fixedContent = await fixTextErrors(_contentController.text);
    if (fixedContent != null) {
      setState(() {
        _contentController.text = fixedContent;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().editNoteError)),
      );
    }
  }

  void _shareNote() {
    final text = _contentController.text;
    if (text.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.share, color: ProjectColors.secondColor),
                  title: Text(ProjectTexts().shareWithWp),
                  onTap: () {
                    _shareViaWhatsApp(text);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.share, color: ProjectColors.secondColor),
                  title: Text(ProjectTexts().shareWithSMS),
                  onTap: () {
                    _shareViaSMS(text);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().noteCantNotFound)),
      );
    }
  }

  Future<void> _shareViaWhatsApp(String text) async {
    try {
      final uri = 'whatsapp://send?text=$text';
      // ignore: deprecated_member_use
      await launch(uri);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().whatsappError)),
      );
    }
  }

  Future<void> _shareViaSMS(String text) async {
    try {
      final uri = 'sms:?body=$text';
      // ignore: deprecated_member_use
      await launch(uri);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().smsError)),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: ProjectColors.whiteColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      style: const TextStyle(color: ProjectColors.whiteColor),
      maxLines: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ProjectTexts().noteDetailsTitle)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _titleController,
                  labelText: ProjectTexts().addNoteInputTitle,
                ),
                const CustomSizedBox(),
                _buildTextField(
                  controller: _contentController,
                  labelText: ProjectTexts().addNoteInputNote,
                ),
                const CustomSizedBox(),
                ElevatedButton(
                  onPressed: _updateNote,
                  child: Text(ProjectTexts().save),
                ),
                const CustomSizedBox(),
                ElevatedButton(
                  onPressed: _summarizeNote,
                  child: Text(ProjectTexts().summarize),
                ),
                const CustomSizedBox(),
                ElevatedButton(
                  onPressed: _fixErrors,
                  child: Text(ProjectTexts().fixErrors),
                ),
                const CustomSizedBox(),
                ElevatedButton(
                  onPressed: _improveNote,
                  child: Text(ProjectTexts().developrNote),
                ),
                const CustomSizedBox(),
                ElevatedButton(
                  onPressed: _shareNote,
                  child: Text(ProjectTexts().share),
                ),
                const CustomSizedBox(),
                ElevatedButton(
                  onPressed: _deleteNote,
                  child: Text(ProjectTexts().delete),
                ),
                const CustomSizedBox(),
                _isImprovedVisible
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ProjectColors.cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              ProjectTexts().developedNotes,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ProjectColors.firstColor,
                              ),
                            ),
                            const CustomSizedBox(),
                            SelectableText(
                              _improvedContent,
                              style: const TextStyle(
                                color: ProjectColors.whiteColor,
                              ),
                            ),
                            const CustomSizedBox(),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isImprovedVisible = false;
                                });
                              },
                              child: Text(
                                ProjectTexts().close,
                                style: const TextStyle(
                                    color: ProjectColors.secondColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SpinKitRipple(
                  color: ProjectColors.secondColor,
                  size: 200.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
