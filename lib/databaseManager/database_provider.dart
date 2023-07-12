import 'package:note_app2/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "note_app.db"),
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            creation_date DATE
          )
        ''');
    }, version: 1);
  }

  addNewNote(NoteModel note) async {
    final db = await database;
    db?.insert("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> getNotes() async {
    final db = await database;
    var res = await db!.query("notes");
    return res.toList();
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    int count = await db!.rawDelete("DELETE FROM notes WHERE id = ?", [id]);
    return count;
  }

  Future<void> editNotes(NoteModel note) async {
    final db = await database;
    await db!
        .update("notes", note.toMap(), where: "id = ?", whereArgs: [note.id]);
  }
}
