import 'package:flutter/material.dart';
import 'package:note_app2/databaseManager/database_provider.dart';
import 'package:note_app2/main.dart';
import 'package:note_app2/models/note_model.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required note});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title;
  late String body;
  late DateTime date;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addNote(NoteModel note) {
    DatabaseProvider.db.addNewNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              maxLength: 20,
              autocorrect: true,
              keyboardType: TextInputType.text,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Note Title"),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: TextField(
              controller: bodyController,
              enableSuggestions: true,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your note",
                  errorStyle: TextStyle(color: Colors.red),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red))),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            date = DateTime.now();
          });
          NoteModel note =
              NoteModel(title: title, body: body, creationDate: date);
          addNote(note);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        },
        label: const Text("Save Note"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
