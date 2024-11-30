import 'package:flutter/material.dart';
import 'package:inventool/utils/database_helper.dart';

class AddSQLToolScreen extends StatefulWidget {
  const AddSQLToolScreen({super.key});

  @override
  _AddSQLToolScreenState createState() => _AddSQLToolScreenState();
}

class _AddSQLToolScreenState extends State<AddSQLToolScreen> {
  final TextEditingController _sqlController = TextEditingController();
  String _message = '';

  void _executeSQL() async {
    final sql = _sqlController.text.trim();
    if (sql.isNotEmpty) {
      if (sql.toUpperCase().startsWith('INSERT') &&
          (sql.contains('Personas') || sql.contains('Herramientas'))) {
        try {
          await DatabaseHelper().executeDevSQL(sql);
          setState(() {
            _message = 'Instrucción SQL ejecutada con éxito.';
          });
        } catch (e) {
          setState(() {
            _message = 'Error al ejecutar la instrucción SQL: $e';
          });
        }
      } else {
        setState(() {
          _message =
              'No tan rapido cowboy, quizas este comando no sea seguro para ejecutar en la base de datos. Ponte en contacto con el administrador si crees que tienes que ejecutar este comando.';
        });
      }
    } else {
      setState(() {
        _message = 'Por favor, ingrese una instrucción SQL.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejecutar Instrucción SQL'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Advertencia: Esta pantalla permite ejecutar instrucciones SQL directamente en la base de datos. Usar con precaución, ya que el programa podría corromperse si se realizan cambios innecesarios.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _sqlController,
              decoration: const InputDecoration(
                labelText: 'Instrucción SQL',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _executeSQL,
              child: const Text('Ejecutar SQL'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
