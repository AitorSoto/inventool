import 'package:flutter/material.dart';
import '../utils/database_helper.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Map<String, dynamic>> _tools = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadTools();
  }

  void _loadTools() async {
    final tools = await DatabaseHelper().getHerramientas();
    setState(() {
      _tools = tools.where((tool) => tool['idPersona'] != null).toList();
    });
  }

  void _filterTools(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTools = _tools.where((tool) {
      final toolName = tool['nombre'].toLowerCase();
      return toolName.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Herramientas Asignadas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterTools,
              decoration: InputDecoration(
                labelText: 'Buscar herramienta',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTools.length,
              itemBuilder: (context, index) {
                final tool = filteredTools[index];
                return ListTile(
                  title: Text(tool['nombre']),
                  subtitle: Text("ID Persona: ${tool['idPersona']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
