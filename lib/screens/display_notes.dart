import 'package:flutter/material.dart';
import 'package:note_app2/databaseManager/database_provider.dart';
import 'package:note_app2/models/note_model.dart';
import 'package:note_app2/screens/edit_notes.dart';

// ignore: must_be_immutable
class ShowNote extends StatefulWidget {
  NoteModel? note;
  ShowNote({Key? key, required this.note}) : super(key: key);

  @override
  State<ShowNote> createState() => _ShowNoteState();
}

class _ShowNoteState extends State<ShowNote> {
  @override
  Widget build(BuildContext context) {
    final NoteModel note =
        ModalRoute.of(context)?.settings.arguments as NoteModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Note"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        title: const Text("Are you sure to delete this"),
                        content: Text("${note.title} will be deleted"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                DatabaseProvider.db.deleteNote(note.id!);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/", (route) => false);
                              },
                              child: const Text("Delete")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"))
                        ],
                      );
                    }));
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note.title,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                note.body,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  EditNotes(note: note, creationDate: DateTime.now())));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
