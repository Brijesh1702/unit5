import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: StudentSQLiteApp()));
}

class StudentSQLiteApp extends StatefulWidget {
  const StudentSQLiteApp({super.key});

  @override
  State<StudentSQLiteApp> createState() => _StudentSQLiteAppState();
}

class _StudentSQLiteAppState extends State<StudentSQLiteApp> {
  Database? _database;
  List<Map<String, dynamic>> _students = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  Future<void> _initDB() async {
    String path = join(await getDatabasesPath(), 'students_db.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
    );
    _refreshStudents();
  }

  Future<void> _refreshStudents() async {
    final List<Map<String, dynamic>> data = await _database!.query('students');
    setState(() {
      _students = data;
    });
  }

  // 1. Insert Record
  Future<void> _addStudent() async {
    if (_nameController.text.isEmpty) return;
    await _database!.insert('students', {'name': _nameController.text});
    _nameController.clear();
    _refreshStudents();
  }

  // 2. Update Record
  Future<void> _updateStudent(int id) async {
    await _database!.update(
      'students',
      {'name': '${_nameController.text} (Updated)'},
      where: 'id = ?',
      whereArgs: [id],
    );
    _nameController.clear();
    _refreshStudents();
  }

  // 3. Delete Record
  Future<void> _deleteStudent(int id) async {
    await _database!.delete('students', where: 'id = ?', whereArgs: [id]);
    _refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Student CRUD")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Student Name", suffixIcon: Icon(Icons.person)),
            ),
          ),
          ElevatedButton(onPressed: _addStudent, child: const Text("Insert Student")),
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return ListTile(
                  title: Text(student['name']),
                  subtitle: Text("ID: ${student['id']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _updateStudent(student['id'])),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteStudent(student['id'])),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
