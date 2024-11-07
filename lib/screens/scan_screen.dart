import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/scanned_object.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String? scannedData;

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
