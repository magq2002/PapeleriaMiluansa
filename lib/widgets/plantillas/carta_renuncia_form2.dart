// widgets/plantillas/carta_renuncia_form2.dart
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CartaRenunciaForm2 extends StatefulWidget {
  final Function(Map<String, String>) onFormSubmit;

  const CartaRenunciaForm2({required this.onFormSubmit, Key? key})
      : super(key: key);

  @override
  State<CartaRenunciaForm2> createState() => _CartaRenunciaForm2State();
}

class _CartaRenunciaForm2State extends State<CartaRenunciaForm2> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _cargoController = TextEditingController();
  final _empresaController = TextEditingController();
  final _fechaController = TextEditingController();

  void _generarCarta() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nombre': _nombreController.text,
        'cedula': _cedulaController.text,
        'cargo': _cargoController.text,
        'empresa': _empresaController.text,
        'fecha': _fechaController.text,
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
                    pw.Text('${data['fecha']}'),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Carta de Renuncia Laboral',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'A quien corresponda:\n\n'
                  'Por medio de la presente, quiero manifestar mi decisión de renunciar de manera voluntaria al cargo de ${data['cargo']} que vengo desempeñando en la empresa ${data['empresa']}.\n\n'
                  'Mi nombre es ${data['nombre']}, identificado(a) con cédula de ciudadanía No. ${data['cedula']}. Esta decisión ha sido tomada tras una profunda reflexión y responde a motivos personales/profesionales.\n\n'
                  'Expreso mi gratitud por las oportunidades brindadas, por el ambiente de trabajo y por todo lo aprendido durante mi permanencia en la empresa.\n\n'
                  'Reitero mi compromiso de apoyar el proceso de transición de manera responsable y ordenada.\n\n\n'
                  'Cordialmente,\n\n'
                  '${data['nombre']}\n'
                  'C.C. ${data['cedula']}',
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
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre completo'),
            validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
          ),
          TextFormField(
            controller: _cedulaController,
            decoration: InputDecoration(labelText: 'Cédula'),
            validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
          ),
          TextFormField(
            controller: _cargoController,
            decoration: InputDecoration(labelText: 'Cargo'),
            validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
          ),
          TextFormField(
            controller: _empresaController,
            decoration: InputDecoration(labelText: 'Empresa'),
            validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
          ),
          TextFormField(
            controller: _fechaController,
            decoration: InputDecoration(labelText: 'Fecha de renuncia'),
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
