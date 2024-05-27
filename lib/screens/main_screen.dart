import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_ai/models/note.dart';
import 'package:note_ai/product/custom_widgets.dart';
import 'package:note_ai/product/project_colors.dart';
import 'package:note_ai/product/project_texts.dart';
import 'package:note_ai/screens/add_note_screen.dart';
import 'package:note_ai/screens/edit_note_screen.dart';
import 'package:note_ai/screens/first_screen.dart';

// ignore: use_key_in_widget_constructors
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectTexts().projectName),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: PopupMenuButton(
              icon:
                  const Icon(Icons.more_vert, color: ProjectColors.whiteColor),
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
                        const Icon(Icons.logout,
                            color: ProjectColors.whiteColor),
                        const CustomSizedBox(boxSize: 8),
                        Text(ProjectTexts().logOut,
                            style: const TextStyle(
                                color: ProjectColors.whiteColor)),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList() {
    return StreamBuilder(
      stream: _getNotesStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(ProjectTexts().anyErrorMessage));
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
              color: ProjectColors.cardColor,
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () async {
                  final editedNote = await _editNote(context, note);
                  if (editedNote != null) {
                    FirebaseFirestore.instance
                        .collection('notes')
                        .doc(note.id)
                        .update(editedNote.toMap());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const CustomSizedBox(boxSize: 8),
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
      return FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
    return const Stream.empty();
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
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const FirstScreen()),
      (route) => false,
    );
  }

  String _truncateText(String text, int limit) {
    if (text.length <= limit) return text;
    // ignore: prefer_interpolation_to_compose_strings
    return text.substring(0, limit) + "...";
  }
}
