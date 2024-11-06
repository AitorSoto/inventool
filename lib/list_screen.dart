import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  final List<Map<String, String>> items = [
    {"id": "1", "name": "Item 1"},
    {"id": "2", "name": "Item 2"},
    {"id": "3", "name": "Item 3"},
    {"id": "4", "name": "Item 4"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Elementos"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(items[index]["name"]!),
              subtitle: Text("ID: ${items[index]["id"]}"),
            ),
          );
        },
      ),
    );
  }
}
