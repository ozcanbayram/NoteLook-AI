import 'package:flutter/material.dart';
import 'package:note_ai/models/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notu Düzenle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Başlık'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                decoration: InputDecoration(hintText: 'İçerik'),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final editedNote = Note(
                  title: titleController.text,
                  content: contentController.text,
                );
                Navigator.pop(context, editedNote);
              },
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
