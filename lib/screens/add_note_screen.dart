import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/product/custom_widgets.dart';
import 'package:note_ai/product/project_texts.dart';

// ignore: use_key_in_widget_constructors
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
          CollectionReference notes =
              FirebaseFirestore.instance.collection('notes');
          await notes.add({
            'title': title,
            'content': content,
            'userId': user.uid,
          });
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } catch (e) {
        // ignore: avoid_print
        print('Hata oluştu: $e'); //Hatayı görebilmek için.
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ProjectTexts().alertAddNote)),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return CustomTextField(lineLimit: null,
      controller: controller,
      labeltext: labelText,
      errorMessage: ProjectTexts().inputTitle,
      fieldType: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ProjectTexts().addNoteTitle)),
      body: SingleChildScrollView(
        child: Padding(
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
                onPressed: () => _addNote(context),
                child: Text(ProjectTexts().save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
