import 'package:flutter/material.dart';
import 'package:inventool/utils/database_helper.dart';
import 'package:inventool/models/tool.dart';

class EditToolScreen extends StatefulWidget {
  final Tool tool;

  const EditToolScreen({super.key, required this.tool});

  @override
  _EditToolScreenState createState() => _EditToolScreenState();
}

class _EditToolScreenState extends State<EditToolScreen> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _idPersonaController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.tool.id.toString());
    _nameController = TextEditingController(text: widget.tool.name);
    _idPersonaController =
        TextEditingController(text: widget.tool.brotherId.toString());
  }

  void _updateHerramienta() async {
    final id = _idController.text;
    final name = _nameController.text;
    final idPersona = int.tryParse(_idPersonaController.text);

    if (name.isNotEmpty &&
        (widget.tool.brotherId != null ? idPersona != null : true)) {
      await DatabaseHelper()
          .updateTool(Tool(id: id, name: name, brotherId: idPersona));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  void _deleteHerramienta() async {
    await DatabaseHelper().deleteTool(widget.tool.id);
    Navigator.pop(context, true); // Indicar que se ha eliminado la herramienta
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Herramienta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text(
                      '¿Estás seguro de que deseas eliminar esta herramienta?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                _deleteHerramienta();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
              readOnly: true, // No permitir editar el ID
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            if (widget.tool.brotherId != null)
              TextField(
                controller: _idPersonaController,
                decoration: const InputDecoration(labelText: 'ID Persona'),
                keyboardType: TextInputType.number,
                readOnly: true, // No permitir editar el ID de la persona
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateHerramienta,
              child: const Text('Actualizar Herramienta'),
            ),
          ],
        ),
      ),
    );
  }
}
