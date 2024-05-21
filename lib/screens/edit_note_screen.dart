import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/models/note.dart';
import 'package:note_ai/services/ai_service.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

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
          CollectionReference notes = FirebaseFirestore.instance.collection('notes');
          await notes.doc(widget.note.id).update({
            'title': newTitle,
            'content': newContent,
          });
          Navigator.pop(context);
        }
      } catch (e) {
        print('Hata oluştu: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Başlık ve içerik boş olamaz')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Özetleme işlemi başarısız oldu')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notu geliştirme işlemi başarısız oldu')),
      );
    }
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notu Sil'),
          content: Text('Bu notu silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hayır'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
                  await notes.doc(widget.note.id).delete();
                  Navigator.pop(context);
                  Navigator.pop(context); 
                } catch (e) {
                  print('Hata oluştu: $e');
                }
              },
              child: Text('Evet'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hataları düzeltme işlemi başarısız oldu')),
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
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.share, color: Colors.blue),
                  title: Text('WhatsApp ile Paylaş'),
                  onTap: () {
                    _shareViaWhatsApp(text);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share, color: Colors.blue),
                  title: Text('SMS ile Paylaş'),
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
        SnackBar(content: Text('Paylaşılacak not bulunamadı')),
      );
    }
  }

  Future<void> _shareViaWhatsApp(String text) async {
    try {
      final uri = 'whatsapp://send?text=$text';
      await launch(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('WhatsApp açılamadı')),
      );
    }
  }

  Future<void> _shareViaSMS(String text) async {
    try {
      final uri = 'sms:?body=$text';
      await launch(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SMS açılamadı')),
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
        labelStyle: TextStyle(color: Colors.white),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      style: TextStyle(color: Colors.white),
      maxLines: null, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notu Düzenle')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _titleController,
                  labelText: 'Başlık',
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _contentController,
                  labelText: 'İçerik',
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateNote,
                  child: Text('Kaydet'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _summarizeNote,
                  child: Text('Özetle'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _fixErrors,
                  child: Text('Hataları Onar'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _improveNote,
                  child: Text('Notumu Geliştir'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _shareNote,
                  child: Text('Paylaş'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _deleteNote,
                  child: Text('Sil'),
                ),
                SizedBox(height: 16),
                _isImprovedVisible
                    ? Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 18, 18, 18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Geliştirilmiş Not:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen,
                              ),
                            ),
                            SizedBox(height: 8),
                            SelectableText(
                              _improvedContent,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isImprovedVisible = false;
                                });
                              },
                              child: Text(
                                'Kapat',
                                style: TextStyle(color: Colors.blue),
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
              child: Center(
                child: SpinKitRipple(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

