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

  Future<void> _loadTools() async {
    final tools = await DatabaseHelper().getHerramientas();
    setState(() {
      _tools = tools;
    });
  }

  void _filterTools(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  Future<String> _getToolOwner(int? idPersona) async {
    if (idPersona == null) return "Nadie";
    final ownerName = await DatabaseHelper().getVolunteerNameById(idPersona);
    return ownerName;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTools = _tools.where((tool) {
      final toolName = tool['nombre'].toLowerCase();
      return toolName.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Herramientas Asignadas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterTools,
              decoration: const InputDecoration(
                labelText: 'Buscar herramienta',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadTools,
              child: ListView.builder(
                itemCount: filteredTools.length,
                itemBuilder: (context, index) {
                  final tool = filteredTools[index];
                  return ListTile(
                    title: Text(tool['nombre']),
                    subtitle: FutureBuilder<String>(
                      future: _getToolOwner(tool['idPersona']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Cargando...");
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Text("En posesión de: ${snapshot.data}");
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
