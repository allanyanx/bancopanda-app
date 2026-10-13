import 'package:flutter/material.dart';

class LoadError extends StatelessWidget {
  const LoadError({
    super.key,
    required this.mensaje,
    required this.onReintentar,
  });

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(Icons.error_outline, size: 20, color: theme.colorScheme.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            mensaje,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
        TextButton(onPressed: onReintentar, child: const Text('Reintentar')),
      ],
    );
  }
}
