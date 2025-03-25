// widgets/plantillas/carta_referencia_personal_form2.dart
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CartaReferenciaPersonalForm2 extends StatefulWidget {
  final Function(Map<String, String>) onFormSubmit;

  const CartaReferenciaPersonalForm2({required this.onFormSubmit, Key? key})
      : super(key: key);

  @override
  State<CartaReferenciaPersonalForm2> createState() =>
      _CartaReferenciaPersonalForm2State();
}

class _CartaReferenciaPersonalForm2State
    extends State<CartaReferenciaPersonalForm2> {
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
                  'Carta de Referencia Personal',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'A quien pueda interesar:\n\n\n\n'
                  'Por medio de la presente, me permito recomendar ampliamente a ${data['recomendado']}, '
                  'identificado con cédula de ciudadanía número ${data['cedula_recomendado']}, a quien conozco desde hace aproximadamente ${data['tiempo']} años.\n\n'
                  'Durante este tiempo, he tenido la oportunidad de compartir con ${data['recomendado']} en diferentes espacios y he podido evidenciar su buen comportamiento, honestidad y compromiso en cada una de sus responsabilidades. '
                  'Se trata de una persona confiable, amable y respetuosa, cualidades que considero valiosas en cualquier entorno social o laboral.\n\n'
                  'Por esta razón, no tengo inconveniente alguno en servirle como referencia personal y quedo atento a cualquier información adicional que se requiera.\n\n\n\n\n'
                  'Cordialmente,\n'
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
    );
  }
}
