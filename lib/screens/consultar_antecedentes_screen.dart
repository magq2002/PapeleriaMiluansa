import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultarAntecedentesScreen extends StatefulWidget {
  const ConsultarAntecedentesScreen({super.key});

  @override
  State<ConsultarAntecedentesScreen> createState() =>
      _ConsultarAntecedentesScreen();
}

class _ConsultarAntecedentesScreen extends State<ConsultarAntecedentesScreen> {
  //final _cedulaController = TextEditingController();

  void _consultar(String titulo, String url) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Abrir $titulo'),
        content: const Text(
            '¿Deseas abrir esta página en tu navegador para consultar el certificado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Abrir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el navegador')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar Antecedentes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              //controller: _cedulaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cédula del ciudadano',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _consultar(
                'ADRES',
                'https://www.adres.gov.co/consulte-su-eps',
              ),
              child: const Text('Consultar ADRES'),
            ),
            ElevatedButton(
              onPressed: () => _consultar(
                'Procuraduría',
                'https://www.procuraduria.gov.co/Pages/Consulta-de-Antecedentes.aspx',
              ),
              child: const Text('Consultar Procuraduría'),
            ),
            ElevatedButton(
              onPressed: () => _consultar(
                'Contraloría',
                'https://www.contraloria.gov.co/web/guest/persona-natural',
              ),
              child: const Text('Consultar Contraloría'),
            ),
            ElevatedButton(
              onPressed: () => _consultar(
                'Policía',
                'https://antecedentes.policia.gov.co:7005/WebJudicial/',
              ),
              child: const Text('Consultar Policía'),
            ),
          ],
        ),
      ),
    );
  }
}
