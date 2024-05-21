import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/models/note.dart';
import 'package:note_ai/services/ai_service.dart'; // AI servis fonksiyonunun bulunduğu dosyayı import edin

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
                  Navigator.pop(context); // Bu ekranı ve önceki ekranı kapat
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      maxLines: null, // Birden fazla satıra izin ver
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notu Düzenle')),
      body: SingleChildScrollView(
        child: Padding(
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
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Özetle'),
              ),
             
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _fixErrors,
                child: Text('Onar'),
              ),
               SizedBox(height: 8),
              ElevatedButton(
                onPressed: _deleteNote,
                child: Text('Sil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
