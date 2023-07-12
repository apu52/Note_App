import 'package:flutter/material.dart';
import 'package:note_app2/databaseManager/database_provider.dart';
import 'package:note_app2/models/note_model.dart';
import 'package:note_app2/screens/add_note.dart';
import 'package:note_app2/screens/display_notes.dart';
// import 'package:note_app2/screens/splash_screen.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detectSystemTheme();
  }

  void _detectSystemTheme() async {
    final brightness = MediaQuery.of(context).platformBrightness;

    setState(() {
      _themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        "/home": (context) => const HomeScreen(),
        "/AddNote": (context) => const AddNote(
              note: null,
            ),
        "/ShowNote": (context) => ShowNote(
              note: null,
            ),
      },
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Map<String, Object?>>> getNotes() async {
    try {
      final notes = await DatabaseProvider.db.getNotes();
      return notes;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getNotes(),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> noteData) {
            switch (noteData.connectionState) {
              case ConnectionState.waiting:
                {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              case ConnectionState.done:
                {
                  if (noteData.data == null || noteData.data!.isEmpty) {
                    return Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "You dont have any notes yet, try creating it!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.048),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: noteData.data?.length,
                        itemBuilder: (context, index) {
                          String title = noteData.data![index]['title'];
                          String body = noteData.data![index]['body'];
                          DateTime creationDate = DateTime.parse(
                              noteData.data![index]['creation_date']);
                          int id = noteData.data![index]['id'];
                          DateFormat dateFormat = DateFormat('dd/MM/y');
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, "/ShowNote",
                                    arguments: NoteModel(
                                        title: title,
                                        body: body,
                                        creation_date: creationDate,
                                        id: id));
                              },
                              title: Text(
                                title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          Text(dateFormat.format(creationDate)))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              default:
                {
                  return Center(
                    child: Text(
                        "Unhandled connection state: ${noteData.connectionState}"),
                  );
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/AddNote");
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
