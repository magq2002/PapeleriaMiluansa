import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificadoScreen extends StatefulWidget {
  @override
  _CertificadoScreenState createState() => _CertificadoScreenState();
}

class _CertificadoScreenState extends State<CertificadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _cargoController = TextEditingController();
  final _tiempoController = TextEditingController();

  void _generarPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('CERTIFICADO LABORAL',
                    style: pw.TextStyle(
                        fontSize: 22, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text(
                  'A quien corresponda:\n\n'
                  'Por medio de la presente se certifica que el/la señor(a) ${_nombreController.text}, '
                  'identificado(a) con cédula ${_cedulaController.text}, desempeñó el cargo de ${_cargoController.text} '
                  'durante un periodo de ${_tiempoController.text}.\n\n'
                  'Este certificado se expide a solicitud del interesado a los ${DateTime.now().day} días del mes '
                  '${_obtenerMes(DateTime.now().month)} del año ${DateTime.now().year}.',
                  style: pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.justify,
                )
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String _obtenerMes(int mes) {
    const meses = [
      '',
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    return meses[mes];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generar Certificado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre completo'),
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(labelText: 'Cédula'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _cargoController,
                decoration: InputDecoration(labelText: 'Cargo o actividad'),
              ),
              TextFormField(
                controller: _tiempoController,
                decoration: InputDecoration(labelText: 'Tiempo laborado'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _generarPDF,
                child: Text('Generar PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
