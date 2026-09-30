import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: UsernameApp()));
}

class UsernameApp extends StatefulWidget {
  const UsernameApp({super.key});

  @override
  State<UsernameApp> createState() => _UsernameAppState();
}

class _UsernameAppState extends State<UsernameApp> {
  final TextEditingController _controller = TextEditingController();
  String _savedName = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('username') ?? "No name saved";
    });
  }

  _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text);
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shared Prefs: Username")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter Username"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveUsername, child: const Text("Save")),
            const SizedBox(height: 20),
            Text("Saved Name: $_savedName", style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
