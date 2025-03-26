import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'crop_screen.dart';

class UnirCedulaScreen extends StatefulWidget {
  @override
  _UnirCedulaScreenState createState() => _UnirCedulaScreenState();
}

class _UnirCedulaScreenState extends State<UnirCedulaScreen> {
  File? _frontal;
  File? _posterior;

  Future<void> _pickImage(bool isFrontal) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropScreen(
            imageBytes: imageBytes,
            onCropped: (croppedBytes) async {
              final tempDir = Directory.systemTemp;
              final file = File(
                  '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
              await file.writeAsBytes(croppedBytes);

              setState(() {
                if (isFrontal) {
                  _frontal = file;
                } else {
                  _posterior = file;
                }
              });
            },
          ),
        ),
      );
    }
  }

  Future<void> _combinarImagenesEImprimir() async {
    if (_frontal == null || _posterior == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    try {
      final img1 = img.decodeImage(await _frontal!.readAsBytes());
      final img2 = img.decodeImage(await _posterior!.readAsBytes());
      if (img1 == null || img2 == null) return;

      final resized1 = img.copyResize(img1, width: 600);
      final resized2 = img.copyResize(img2, width: 600);

      const espacio = 10;
      final width =
          resized1.width > resized2.width ? resized1.width : resized2.width;
      final height = resized1.height + resized2.height + espacio;

      final merged = img.Image(width: width, height: height);
      img.fill(merged, color: img.ColorRgb8(255, 255, 255));

      img.compositeImage(merged, resized1,
          dstX: (width - resized1.width) ~/ 2, dstY: 0);
      img.compositeImage(merged, resized2,
          dstX: (width - resized2.width) ~/ 2, dstY: resized1.height + espacio);

      final pdf = pw.Document();
      final image = pw.MemoryImage(img.encodeJpg(merged, quality: 80));

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          ),
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unir Cédula')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(true),
                child: Text('Seleccionar frente de cédula'),
              ),
              if (_frontal != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Image.file(_frontal!),
                  ),
                ),
              ElevatedButton(
                onPressed: () => _pickImage(false),
                child: Text('Seleccionar reverso de cédula'),
              ),
              if (_posterior != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Image.file(_posterior!),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _combinarImagenesEImprimir,
                child: Text('Combinar e Imprimir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
