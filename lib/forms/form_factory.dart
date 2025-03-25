// form_factory.dart
import 'package:flutter/material.dart';
import 'package:papeleria_miluansa/widgets/plantillas/carta_referencia_personal_form1.dart';
import 'package:papeleria_miluansa/widgets/plantillas/carta_referencia_personal_form2.dart';
import 'package:papeleria_miluansa/widgets/plantillas/carta_renuncia_form1.dart';
import 'package:papeleria_miluansa/widgets/plantillas/carta_renuncia_form2.dart';

class FormFactory {
  static Widget createForm(String tipoCarta, String plantilla,
      Function(Map<String, String>) onFormSubmit) {
    switch (tipoCarta) {
      case 'Carta de Referencia Personal':
        if (plantilla == 'Plantilla 1') {
          return CartaReferenciaPersonalForm1(onFormSubmit: onFormSubmit);
        } else if (plantilla == 'Plantilla 2') {
          return CartaReferenciaPersonalForm2(onFormSubmit: onFormSubmit);
        }
        break;
      case 'Carta de Renuncia':
        if (plantilla == 'Plantilla 1') {
          return CartaRenunciaForm1(onFormSubmit: onFormSubmit);
        } else if (plantilla == 'Plantilla 2') {
          return CartaRenunciaForm2(onFormSubmit: onFormSubmit);
        }
        break;
      default:
        return Center(
            child: Text('Selecciona un tipo de carta y una plantilla.'));
    }
    return Center(child: Text('Plantilla no encontrada.'));
  }
}
