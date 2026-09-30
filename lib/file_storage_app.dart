import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(home: FileStorageApp()));
}

class FileStorageApp extends StatefulWidget {
  const FileStorageApp({super.key});

  @override
  State<FileStorageApp> createState() => _FileStorageAppState();
}

class _FileStorageAppState extends State<FileStorageApp> {
  final TextEditingController _controller = TextEditingController();
  String _fileContent = "No data yet";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> _writeFile() async {
    final file = await _localFile;
    return file.writeAsString(_controller.text);
  }

  Future<void> _readFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      setState(() {
        _fileContent = contents;
      });
    } catch (e) {
      setState(() {
        _fileContent = "Error reading file";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Storage (path_provider)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter text to save"),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _writeFile, child: const Text("Write to File")),
                ElevatedButton(onPressed: _readFile, child: const Text("Read from File")),
              ],
            ),
            const SizedBox(height: 20),
            Text("File Content: $_fileContent", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
