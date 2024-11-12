import 'package:flutter/material.dart';
import 'package:inventool/screens/edit_tool_screen.dart';
import 'package:inventool/utils/database_helper.dart';
import 'package:inventool/main.dart'; // Importa el archivo donde definiste routeObserver

import '../models/tool.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with RouteAware {
  List<Map<String, dynamic>> _tools = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadTools();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadTools(); // Recargar herramientas cuando la pantalla vuelve a ser visible
  }

  Future<String> _getToolOwner(int? idPersona) async {
    if (idPersona == null) {
      return 'No asignado';
    }
    final db = await DatabaseHelper().database;
    final result =
        await db.query('Personas', where: 'id = ?', whereArgs: [idPersona]);
    return result.isNotEmpty ? result.first['nombre'] as String : 'No asignado';
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

  @override
  Widget build(BuildContext context) {
    final filteredTools = _tools.where((tool) {
      final toolName =
          '${tool['nombre'].toLowerCase()} ${tool['id'].toString().toLowerCase()}';
      return toolName.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Herramientas"),
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
                    title: Text('${tool['id']} - ${tool['nombre']}'),
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
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditToolScreen(
                            tool: Tool(
                              id: tool['id'],
                              name: tool['nombre'],
                              brotherId: tool['idPersona'],
                            ),
                          ),
                        ),
                      );
                      if (updated == true) {
                        _loadTools(); // Recargar herramientas si se actualizó o eliminó una herramienta
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
