import 'package:flutter/material.dart';

import '../utils/database_helper.dart';

class AddVolunteerScreen extends StatefulWidget {
  const AddVolunteerScreen({super.key});

  @override
  _AddVolunteerScreenState createState() => _AddVolunteerScreenState();
}

class _AddVolunteerScreenState extends State<AddVolunteerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  void _addPersona() async {
    if (_nameController.text.isNotEmpty && _idController.text.isNotEmpty) {
      var volunteerExists = await DatabaseHelper().existsVolunteer(
        int.tryParse(_idController.text)!,
      );
      if (volunteerExists) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(
                  "El voluntario con id '${_idController.text}' ya existe"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        return;
      }
      await DatabaseHelper().insertPersona({
        'nombre': _nameController.text,
        'id': int.parse(_idController.text),
      });
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Por favor, comprueba que todos los campos esten completos"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Voluntario")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "ID"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPersona,
              child: const Text("Agregar voluntario"),
            ),
          ],
        ),
      ),
    );
  }
}
