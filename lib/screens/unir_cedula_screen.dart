import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'crop_screen.dart'; // Asegúrate de importar correctamente tu pantalla de recorte

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
              final tempDir = await getTemporaryDirectory();
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

    final img1 = img.decodeImage(await _frontal!.readAsBytes());
    final img2 = img.decodeImage(await _posterior!.readAsBytes());

    if (img1 == null || img2 == null) return;

    const espacio = 20;
    final width = img1.width > img2.width ? img1.width : img2.width;
    final height = img1.height + img2.height + espacio;

    // Crear una imagen en blanco con fondo blanco
    final merged = img.Image(width: width, height: height);
    img.fill(merged, color: img.ColorRgb8(255, 255, 255));

    // Copiar las imágenes en la imagen combinada
    img.compositeImage(merged, img1, dstX: (width - img1.width) ~/ 2, dstY: 0);
    img.compositeImage(merged, img2,
        dstX: (width - img2.width) ~/ 2, dstY: img1.height + espacio);

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/cedula_combinada.jpg');
    await file.writeAsBytes(img.encodeJpg(merged));

    final pdf = pw.Document();
    final imageBytes = await file.readAsBytes();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(child: pw.Image(image)),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unir Cédula')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
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
      ),
    );
  }
}
