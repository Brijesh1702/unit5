import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const DarkModeApp());
}

class DarkModeApp extends StatefulWidget {
  const DarkModeApp({super.key});

  @override
  State<DarkModeApp> createState() => _DarkModeAppState();
}

class _DarkModeAppState extends State<DarkModeApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  _toggleTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: const Text("Dark Mode Toggle")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Theme: ${_isDarkMode ? 'Dark' : 'Light'}", style: const TextStyle(fontSize: 20)),
              Switch(value: _isDarkMode, onChanged: _toggleTheme),
            ],
          ),
        ),
      ),
    );
  }
}
