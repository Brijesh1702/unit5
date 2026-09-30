import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'shared_prefs_username.dart';
import 'shared_prefs_dark_mode.dart';
import 'sqlite_products.dart';
import 'sqlite_insert_student.dart';
import 'sqlite_display_records.dart';
import 'sqlite_update_record.dart';
import 'sqlite_delete_record.dart';
import 'hive_todo.dart';
import 'hive_user_info.dart';
import 'file_storage_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for the Hive-related apps
  await Hive.initFlutter();
  await Hive.openBox('todoBox');
  await Hive.openBox('userBox');

  runApp(const MaterialApp(
    home: MainMenu(),
    debugShowCheckedModeBanner: false,
  ));
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unit 5 Exercises")),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _menuItem(context, "1. Shared Prefs: Username", const UsernameApp()),
          _menuItem(context, "2. Shared Prefs: Dark Mode", const DarkModeApp()),
          _menuItem(context, "3. SQLite: Products Table", const SQLiteProductsApp()),
          _menuItem(context, "4. SQLite: Insert Student", const InsertStudentApp()),
          _menuItem(context, "5. SQLite: Display Students", const DisplayStudentsApp()),
          _menuItem(context, "6. SQLite: Update Student", const UpdateStudentApp()),
          _menuItem(context, "7. SQLite: Delete Student", const DeleteStudentApp()),
          _menuItem(context, "8. Hive: To-Do Note", const HiveTodoApp()),
          _menuItem(context, "9. Hive: User Info (Name & Age)", const HiveUserApp()),
          _menuItem(context, "10. File Storage (path_provider)", const FileStorageApp()),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, Widget target) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => target),
          );
        },
      ),
    );
  }
}
