import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/models/note.dart';

class AddNoteScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addNote(BuildContext context) async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          CollectionReference notes = FirebaseFirestore.instance.collection('notes');
          await notes.add({
            'title': title,
            'content': content,
            'userId': user.uid,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      maxLines: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yeni Not Ekle')),
      body: Padding(
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
              onPressed: () => _addNote(context),
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
