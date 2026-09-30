import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: UpdateStudentApp()));

class UpdateStudentApp extends StatefulWidget {
  const UpdateStudentApp({super.key});
  @override
  State<UpdateStudentApp> createState() => _UpdateStudentAppState();
}

class _UpdateStudentAppState extends State<UpdateStudentApp> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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

  _update() async {
    int? id = int.tryParse(_idController.text);
    if (id != null && _nameController.text.isNotEmpty) {
      int count = await _database!.update(
        'students',
        {'name': _nameController.text},
        where: 'id = ?',
        whereArgs: [id],
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$count record(s) updated")));
      _idController.clear();
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite: Update Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "Enter ID to Update")),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Enter New Name")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _update, child: const Text("Update Student"))
          ],
        ),
      ),
    );
  }
}
