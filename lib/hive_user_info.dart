import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const MaterialApp(home: HiveUserApp()));
}

class HiveUserApp extends StatefulWidget {
  const HiveUserApp({super.key});
  @override
  State<HiveUserApp> createState() => _HiveUserAppState();
}

class _HiveUserAppState extends State<HiveUserApp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final Box _userBox = Hive.box('userBox');

  _saveUser() {
    if (_nameController.text.isNotEmpty && _ageController.text.isNotEmpty) {
      _userBox.put('userData', {
        'name': _nameController.text,
        'age': _ageController.text,
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = _userBox.get('userData');

    return Scaffold(
      appBar: AppBar(title: const Text("Hive: Name and Age")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveUser, child: const Text("Save User Data")),
            const SizedBox(height: 40),
            if (userData != null)
              Text(
                "Stored Info: ${userData['name']}, ${userData['age']} years old",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            else
              const Text("No data stored yet."),
          ],
        ),
      ),
    );
  }
}
