import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_ai/models/note.dart';
import 'package:note_ai/screens/add_note_screen.dart';
import 'package:note_ai/screens/edit_note_screen.dart';
import 'package:note_ai/screens/first_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoteLook'),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'logout') {
                  _signOut(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
        leading: Container(), // Sol üst köşedeki geri butonunu kaldırır
      ),
      body: _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList() {
    return StreamBuilder(
      stream: _getNotesStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu'));
        }
        List<Note> notes = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return Note(
            id: document.id,
            title: data['title'],
            content: data['content'],
          );
        }).toList();

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            final displayedText = _truncateText(note.content, 50);

            return Card(
              color: const Color.fromARGB(255, 18, 18, 18), // Kart arka plan rengi
              margin: EdgeInsets.all(8),
              child: InkWell(
                onTap: () async {
                  final editedNote = await _editNote(context, note);
                  if (editedNote != null) {
                    FirebaseFirestore.instance.collection('notes').doc(note.id).update(editedNote.toMap());
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
                      Text(displayedText),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _getNotesStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('notes').where('userId', isEqualTo: user.uid).snapshots();
    }
    return Stream.empty();
  }

  Future<Note?> _editNote(BuildContext context, Note note) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNoteScreen(note: note)),
    );
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FirstScreen()),
      (route) => false,
    );
  }

  String _truncateText(String text, int limit) {
    if (text.length <= limit) return text;
    return text.substring(0, limit) + "...";
  }
}
