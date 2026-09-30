import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: DeleteStudentApp()));

class DeleteStudentApp extends StatefulWidget {
  const DeleteStudentApp({super.key});
  @override
  State<DeleteStudentApp> createState() => _DeleteStudentAppState();
}

class _DeleteStudentAppState extends State<DeleteStudentApp> {
  final TextEditingController _idController = TextEditingController();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  _initDB() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'students.db'),
      onCreate: (db, version) => db.execute("CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"),
      version: 1,
    );
  }

  _delete() async {
    int? id = int.tryParse(_idController.text);
    if (id != null) {
      int count = await _database!.delete(
        'students',
        where: 'id = ?',
        whereArgs: [id],
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$count record(s) deleted")));
      _idController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite: Delete Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "Enter ID to Delete")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _delete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
