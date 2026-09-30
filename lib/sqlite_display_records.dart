import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: DisplayStudentsApp()));

class DisplayStudentsApp extends StatefulWidget {
  const DisplayStudentsApp({super.key});
  @override
  State<DisplayStudentsApp> createState() => _DisplayStudentsAppState();
}

class _DisplayStudentsAppState extends State<DisplayStudentsApp> {
  Database? _database;
  List<Map<String, dynamic>> _students = [];

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
    _fetchStudents();
  }

  _fetchStudents() async {
    final data = await _database?.query('students');
    setState(() {
      _students = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite: Display Students"),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchStudents)],
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_students[index]['name']),
          subtitle: Text("ID: ${_students[index]['id']}"),
        ),
      ),
    );
  }
}
