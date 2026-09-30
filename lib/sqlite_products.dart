import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: SQLiteProductsApp()));
}

class SQLiteProductsApp extends StatefulWidget {
  const SQLiteProductsApp({super.key});

  @override
  State<SQLiteProductsApp> createState() => _SQLiteProductsAppState();
}

class _SQLiteProductsAppState extends State<SQLiteProductsApp> {
  Database? _database;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  Future<void> _initDB() async {
    String path = join(await getDatabasesPath(), 'products_db.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL)',
        );
      },
    );
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    final List<Map<String, dynamic>> maps = await _database!.query('products');
    setState(() {
      _products = maps;
    });
  }

  Future<void> _addProduct() async {
    await _database!.insert(
      'products',
      {'name': 'Product ${DateTime.now().second}', 'price': 99.99},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Products Table")),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_products[index]['name']),
            subtitle: Text("Price: \$${_products[index]['price']}"),
            trailing: Text("ID: ${_products[index]['id']}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
