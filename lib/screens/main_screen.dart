import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/models/note.dart';
import 'package:note_ai/screens/add_note_screen.dart';
import 'package:note_ai/screens/edit_note_screen.dart';
import 'package:note_ai/screens/first_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Note> notes = []; // Notlarınızı tutacak bir liste

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Not Tutma Uygulaması'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                _signOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Çıkış Yap'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final displayedText = _truncateText(note.content, 50); // Call truncate function

          return Card(
            margin: EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                final editedNote = await _editNote(note);
                if (editedNote != null) {
                  setState(() {
                    notes[index] = editedNote;
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(displayedText), // Use the truncated text
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await _addNote();
          if (newNote != null) {
            setState(() {
              notes.add(newNote);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<Note?> _addNote() async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNoteScreen()),
    );
  }

  Future<Note?> _editNote(Note note) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNoteScreen(note: note)),
    );
  }

  // Function to truncate text with ellipsis (...)
  String _truncateText(String text, int limit) {
    if (text.length <= limit) return text;
    return text.substring(0, limit) + "...";
  }

  // Firebase Authentication ile çıkış yapma işlemi
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FirstScreen()),
      (route) => false,
    );
  }
}
