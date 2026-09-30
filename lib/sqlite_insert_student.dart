import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: InsertStudentApp()));

class InsertStudentApp extends StatefulWidget {
  const InsertStudentApp({super.key});
  @override
  State<InsertStudentApp> createState() => _InsertStudentAppState();
}

class _InsertStudentAppState extends State<InsertStudentApp> {
  final TextEditingController _controller = TextEditingController();
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

  _insert() async {
    if (_controller.text.isNotEmpty) {
      await _database?.insert('students', {'name': _controller.text});
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Student Inserted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite: Insert Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Student Name")),
            ElevatedButton(onPressed: _insert, child: const Text("Insert"))
          ],
        ),
      ),
    );
  }
}
