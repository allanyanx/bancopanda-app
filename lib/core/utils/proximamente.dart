import 'package:flutter/material.dart';

/// Aviso para las funciones que aún no están en el MVP.
void mostrarProximamente(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(
        content: Text('Próximamente'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
}
