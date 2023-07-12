import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_app2/databaseManager/database_provider.dart';
import 'package:note_app2/main.dart';
import 'package:note_app2/models/note_model.dart';

class EditNotes extends StatefulWidget {
  final NoteModel note;
  final DateTime creation_date;

  EditNotes({Key? key, required this.note, required this.creation_date})
      : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  late TextEditingController _updatedTitleController;
  late TextEditingController _updatedBodyController;
  late String title;
  late String body;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    _updatedTitleController = TextEditingController(text: widget.note.title);
    _updatedBodyController = TextEditingController(text: widget.note.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  title = _updatedTitleController.text;
                  body = _updatedBodyController.text;
                  date = DateTime.now();
                });
                NoteModel updatednote = NoteModel(
                    id: widget.note.id,
                    title: title,
                    body: body,
                    creation_date: widget.creation_date);
                await DatabaseProvider.db.editNotes(updatednote);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _updatedTitleController,
                maxLength: 20,
                enableSuggestions: true,
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Note Title"),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _updatedBodyController,
                keyboardType: TextInputType.multiline,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Your note",
                    errorStyle: TextStyle(color: Colors.red),
                    errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
