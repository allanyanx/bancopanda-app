import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/transfer_view_model.dart';

class PasosIndicator extends StatelessWidget {
  const PasosIndicator({super.key, required this.paso});

  static const _total = 4;

  final PasoTransferencia paso;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actual = paso.index + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 1; i <= _total; i++) ...[
              if (i > 1) const SizedBox(width: 6),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 5,
                  decoration: BoxDecoration(
                    color: i <= actual
                        ? AppColors.primary
                        : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Paso $actual de $_total',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
