import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sqflite/sqflite.dart';

import '../models/scanned_object.dart';
import '../utils/database_helper.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String? scannedData;

  Future<void> showInputAlertDialog(BuildContext context, int toolId) async {
    final TextEditingController controller = TextEditingController();
    bool isError = false; // Controla si se muestra el error
    String errorText = ''; // Almacena el mensaje de error

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar/devolver herramienta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Inserta tu identificación',
                  border: const OutlineInputBorder(),
                  errorText: isError
                      ? errorText
                      : null, // Muestra el error si es necesario
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                var volunteerIdExists = await DatabaseHelper().existsVolunteer(
                  int.tryParse(controller.text)!,
                );
                if (!volunteerIdExists) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("La identificación ingresada no existe"),
                  ));
                  return;
                }
                var volunteerIdByToolId = await DatabaseHelper().getIdPersonaById(
                    toolId); // Id de la persona a la que está asignada la herramienta
                if (controller.text.isEmpty) {
                  // Si el campo está vacío, muestra el error
                  isError = true;
                  errorText = 'Por favor, ingresa tu identificación';
                  // Redibuja el diálogo con el error
                  (context as Element).markNeedsBuild();
                } else {
                  var isVolunteerUsingTool =
                      await DatabaseHelper().isVolunteerUsingTool(
                    int.tryParse(controller.text)!,
                  );
                  if (isVolunteerUsingTool) {
                    await DatabaseHelper().returnTool(toolId);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Herramienta devuelta correctamente"),
                    ));
                  } else if (volunteerIdByToolId != null &&
                      volunteerIdByToolId != int.tryParse(controller.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "La herramienta no te está asignada, por favor, verifica tu identificación"),
                    ));
                  } else {
                    await DatabaseHelper().assignToolToVolunteer(
                      toolId,
                      int.tryParse(controller.text)!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Herramienta asignada correctamente"),
                    ));
                  }
                  // Si no está vacío, cierra el diálogo
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enviar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Método para iniciar el escaneo de QR
  Future<void> scanQRCode() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color del botón de cancelación
        'Cancelar', // Texto del botón de cancelación
        true, // Mostrar el flash de la cámara
        ScanMode.QR, // Modo de escaneo (QR)
      );

      if (result != '-1') {
        // '-1' es el código de cancelación
        final data = json.decode(result);
        final scannedObject = ScannedObject(
          id: data["id"],
          name: data["name"],
        );

        setState(() {
          scannedData =
              "ID: ${scannedObject.id}\nNombre: ${scannedObject.name}";
        });

        var toolId = int.tryParse(scannedObject.id)!;

        showInputAlertDialog(context, toolId);
      }
    } catch (e) {
      setState(() {
        scannedData = "Error al escanear el código QR";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear QR"),
      ),
      body: Center(
        child: scannedData != null
            ? Text(
                "Datos escaneados:\n$scannedData",
                textAlign: TextAlign.center,
              )
            : const Text("Presiona el botón para escanear un código QR"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanQRCode,
        tooltip: "Escanear QR",
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
