import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

import '../models/scanned_object.dart';
import '../utils/database_helper.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String? scannedData;

  // Método para mostrar el diálogo de entrada
  Future<void> showInputAlertDialog(BuildContext context, int toolId) async {
    final TextEditingController controller = TextEditingController();
    bool isError = false;
    String errorText = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                  errorText: isError ? errorText : null,
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
                var volunteerIdByToolId =
                    await DatabaseHelper().getIdPersonaById(toolId);
                if (controller.text.isEmpty) {
                  isError = true;
                  errorText = 'Por favor, ingresa tu identificación';
                  (context as Element).markNeedsBuild();
                } else {
                  var isVolunteerUsingTool = await DatabaseHelper()
                      .isVolunteerUsingTool(
                          int.tryParse(controller.text)!, toolId);
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
                        toolId, int.tryParse(controller.text)!);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Herramienta asignada correctamente"),
                    ));
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enviar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AiBarcodeScanner(
            onDispose: () {
              debugPrint("Barcode scanner disposed!");
            },
            hideGalleryButton: false,
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
            ),
            onDetect: (BarcodeCapture capture) {
              final String? scannedValue = capture.barcodes.first.rawValue;
              debugPrint("Barcode scanned: $scannedValue");

              final Object? raw = capture.raw;
              debugPrint("Barcode raw: $raw");

              final List<Barcode> barcodes = capture.barcodes;
              debugPrint("Barcode list: $barcodes");

              if (scannedValue != null) {
                final data = json.decode(scannedValue);
                final scannedObject = ScannedObject(
                  id: data["id"],
                  name: data["name"],
                );
                Navigator.pop(context);
                setState(() {
                  scannedData =
                      "ID: ${scannedObject.id}\nNombre: ${scannedObject.name}";
                });

                var toolId = int.tryParse(scannedObject.id)!;
                showInputAlertDialog(context, toolId);
              }
            },
            validator: (value) {
              if (value.barcodes.isEmpty) {
                return false;
              }
              return true;
            },
          ),
        ),
      );
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
