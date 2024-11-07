import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Personas(
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE Herramientas(
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        idPersona INTEGER,
        FOREIGN KEY (idPersona) REFERENCES Personas (id) ON DELETE SET NULL
      )
      ''');
  }

  Future<int> insertPersona(Map<String, dynamic> persona) async {
    final db = await database;
    return await db.insert('Personas', persona);
  }

  Future<int> insertHerramienta(Map<String, dynamic> herramienta) async {
    final db = await database;
    return await db.insert('Herramientas', herramienta);
  }

  Future<List<Map<String, dynamic>>> getPersonas() async {
    final db = await database;
    return await db.query('Personas');
  }

  Future<List<Map<String, dynamic>>> getHerramientas() async {
    final db = await database;
    return await db.query('Herramientas',
        where: 'idPersona IS NOT NULL', orderBy: 'id');
  }

  Future<String> getVolunteerNameById(int id) async {
    final db = await database;
    final result = await db.query('Personas', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first['nombre'] as String : '';
  }

  Future<void> updateHerramientaPersona(
      int herramientaId, int? personaId) async {
    final db = await database;
    await db.update(
      'Herramientas',
      {'idPersona': personaId},
      where: 'id = ?',
      whereArgs: [herramientaId],
    );
  }
}
