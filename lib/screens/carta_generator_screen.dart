// carta_generator_screen.dart
import 'package:flutter/material.dart';
import 'package:papeleria_miluansa/forms/form_factory.dart';

class CartaGeneratorScreen extends StatefulWidget {
  @override
  _CartaGeneratorScreenState createState() => _CartaGeneratorScreenState();
}

class _CartaGeneratorScreenState extends State<CartaGeneratorScreen> {
  String? _tipoCarta;
  String? _plantilla;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generador de Cartas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _tipoCarta,
              items: [
                'Carta de Referencia Personal',
                'Carta de Renuncia'
              ].map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _tipoCarta = newValue;
                  _plantilla = null;
                });
              },
              decoration:
                  InputDecoration(labelText: 'Selecciona el tipo de carta'),
            ),
            if (_tipoCarta != null)
              DropdownButtonFormField<String>(
                value: _plantilla,
                items: _obtenerPlantillasPorTipo(_tipoCarta!)
                    .map((String plantilla) {
                  return DropdownMenuItem<String>(
                    value: plantilla,
                    child: Text(plantilla),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _plantilla = newValue;
                  });
                },
                decoration:
                    InputDecoration(labelText: 'Selecciona la plantilla'),
              ),
            SizedBox(height: 20),
            if (_tipoCarta != null && _plantilla != null)
              FormFactory.createForm(_tipoCarta!, _plantilla!, _onFormSubmit),
          ],
        ),
      ),
    );
  }

  List<String> _obtenerPlantillasPorTipo(String tipoCarta) {
    switch (tipoCarta) {
      case 'Carta de Referencia Personal':
      case 'Carta de Renuncia':
        return ['Plantilla 1', 'Plantilla 2'];
      default:
        return [];
    }
  }

  void _onFormSubmit(Map<String, String> formData) {
    // Aquí podrías guardar el archivo o imprimir
    print('Datos del formulario: $formData');
  }
}
