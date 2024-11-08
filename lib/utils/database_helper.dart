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
    return await db.query('Herramientas', orderBy: 'id');
  }

  Future<int?> getIdPersonaById(int id) async {
    final db = await database;
    final result =
        await db.query('Herramientas', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first['idPersona'] as int? : null;
  }

  Future<String> getVolunteerNameById(int id) async {
    final db = await database;
    final result = await db.query('Personas', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first['nombre'] as String : '';
  }

  Future<void> assignToolToVolunteer(int toolId, int volunteerId) async {
    final db = await database;
    await db.update('Herramientas', {'idPersona': volunteerId},
        where: 'id = ?', whereArgs: [toolId]);
  }

  Future<void> returnTool(int toolId) async {
    final db = await database;
    await db.update('Herramientas', {'idPersona': null},
        where: 'id = ?', whereArgs: [toolId]);
  }

  Future<bool> isToolBeingUsed(int toolId) async {
    final db = await database;
    final result = await db.query('Herramientas',
        where: 'id = ? AND idPersona IS NOT NULL', whereArgs: [toolId]);
    return result.isNotEmpty;
  }

  Future<bool> isVolunteerUsingTool(int volunteerId, int toolId) async {
    final db = await database;
    final result = await db.query('Herramientas',
        where: 'idPersona = ? and id = ?', whereArgs: [volunteerId, toolId]);
    return result.isNotEmpty;
  }

  Future<bool> existsVolunteer(int id) async {
    final db = await database;
    final result = await db.query('Personas', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<bool> existsTool(int id) async {
    final db = await database;
    final result =
        await db.query('Herramientas', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
