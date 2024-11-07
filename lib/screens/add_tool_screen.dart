import 'package:flutter/material.dart';

import '../utils/database_helper.dart';

class AddToolScreen extends StatefulWidget {
  const AddToolScreen({super.key});

  @override
  _AddToolScreenState createState() => _AddToolScreenState();
}

class _AddToolScreenState extends State<AddToolScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idToolController = TextEditingController();
  int? _selectedPersona;

  void _addHerramienta() async {
    if (_nameController.text.isNotEmpty && _idToolController.text.isNotEmpty) {
      await DatabaseHelper().insertHerramienta({
        'id': int.parse(_idToolController.text),
        'nombre': _nameController.text,
        'idPersona': _selectedPersona,
      });
      Navigator.pop(context);
    }
  }

  Future<List<Map<String, dynamic>>> _loadPersonas() async {
    return await DatabaseHelper().getPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Herramienta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idToolController,
              decoration:
                  const InputDecoration(labelText: "ID de la herramienta"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadPersonas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField<int>(
                  hint: const Text("Asignar a persona (opcional)"),
                  items: snapshot.data!.map((persona) {
                    return DropdownMenuItem<int>(
                      value: persona['id'],
                      child: Text(persona['nombre']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPersona = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addHerramienta,
              child: const Text("Agregar Herramienta"),
            ),
          ],
        ),
      ),
    );
  }
}
