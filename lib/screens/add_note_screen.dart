import 'package:flutter/material.dart';
import 'package:note_ai/models/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = ''; // Başlık boş olsun (isteğe bağlı)
    contentController.text = ''; // İçerik boş olsun (isteğe bağlı)
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
        title: Text('Yeni Not'),
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
                maxLines: null, // Çok satırlı metne izin verir
                decoration: InputDecoration(
                  hintText: 'Notunuzu buraya yazın...',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newNote = Note(
                  title: titleController.text,
                  content: contentController.text,
                );
                Navigator.pop(context, newNote); // Kaydedilen notu döndür
              },
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
