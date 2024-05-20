import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/models/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

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

  void _updateNote() async {
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

  void _deleteNote() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notu Sil'),
          content: Text('Bu notu silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Evet'),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      try {
        CollectionReference notes = FirebaseFirestore.instance.collection('notes');
        await notes.doc(widget.note.id).delete();
        Navigator.pop(context);
      } catch (e) {
        print('Hata oluştu: $e');
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: _deleteNote,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text('Sil'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notu Düzenle')),
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
              onPressed: _updateNote,
              child: Text('Kaydet'),
            ),
            SizedBox(height: 8),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }
}
