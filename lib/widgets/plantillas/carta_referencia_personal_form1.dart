// widgets/plantillas/carta_referencia_personal_form1.dart
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CartaReferenciaPersonalForm1 extends StatefulWidget {
  final Function(Map<String, String>) onFormSubmit;

  const CartaReferenciaPersonalForm1({required this.onFormSubmit, Key? key})
      : super(key: key);

  @override
  State<CartaReferenciaPersonalForm1> createState() =>
      _CartaReferenciaPersonalForm1State();
}

class _CartaReferenciaPersonalForm1State
    extends State<CartaReferenciaPersonalForm1> {
  final _formKey = GlobalKey<FormState>();

  final _fechaController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _recomendanteController = TextEditingController();
  final _cedulaRecomendanteController = TextEditingController();
  final _recomendadoController = TextEditingController();
  final _cedulaRecomendadoController = TextEditingController();
  final _telefonoRecomendanteController = TextEditingController();
  final _tiempoController = TextEditingController();

  void _generarCarta() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'fecha': _fechaController.text,
        'ciudad': _ciudadController.text,
        'recomendante': _recomendanteController.text,
        'cedula_recomendante': _cedulaRecomendanteController.text,
        'telefono_recomendante': _telefonoRecomendanteController.text,
        'tiempo': _tiempoController.text,
        'recomendado': _recomendadoController.text,
        'cedula_recomendado': _cedulaRecomendadoController.text,
      };

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Spacer(),
                    pw.Text('${data['ciudad']}, ${data['fecha']}'),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Carta de Referencia Personal \n\n\n',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'A quien corresponda: \n\n\n\n'
                  'Me permito presentar la siguiente carta de referencia personal a favor de ${data['recomendado']}, '
                  'identificado con cédula ${data['cedula_recomendado']} a quien conozco desde hace aproximadamente ${data['tiempo']} años.\n\n'
                  'Durante este tiempo, he podido conocer a fondo su integridad, responsabilidad y comportamiento ético. '
                  '${data['recomendado']} se ha caracterizado por ser una persona honesta, respetuosa, colaboradora '
                  'y confiable, cualidades que, sin duda, le permiten desenvolverse de manera adecuada en diferentes '
                  'entornos sociales y laborales. \n\n\n\n\n\n'
                  'Atentamente:\n'
                  '${data['recomendante']}\n'
                  '${data['cedula_recomendante']}\n'
                  '${data['telefono_recomendante']}',
                  style: pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
      widget.onFormSubmit(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _fechaController,
              decoration: InputDecoration(labelText: 'Fecha'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _ciudadController,
              decoration: InputDecoration(labelText: 'Ciudad'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _recomendanteController,
              decoration:
                  InputDecoration(labelText: 'Nombre de quien recomienda'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _cedulaRecomendanteController,
              decoration:
                  InputDecoration(labelText: 'Cédula de quien recomienda'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _telefonoRecomendanteController,
              decoration:
                  InputDecoration(labelText: 'Telefono de quien recomienda'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _tiempoController,
              decoration:
                  InputDecoration(labelText: 'Tiempo que se conocen en años'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _recomendadoController,
              decoration: InputDecoration(labelText: 'Nombre del recomendado'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _cedulaRecomendadoController,
              decoration: InputDecoration(labelText: 'Cédula del recomendado'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generarCarta,
              child: Text('Generar Carta e Imprimir'),
            ),
          ],
        ),
      ),
    );
  }
}
