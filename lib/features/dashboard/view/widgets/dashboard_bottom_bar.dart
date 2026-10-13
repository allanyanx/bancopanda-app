import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/proximamente.dart';

class DashboardBottomBar extends StatelessWidget {
  const DashboardBottomBar({super.key});

  static const _inicio = 0;
  static const _movimientos = 2;
  static const _cuenta = 3;

  void _irA(BuildContext context, int indice) {
    switch (indice) {
      case _inicio:
        break;
      case _movimientos:
        context.push(AppRoutes.movements);
      case _cuenta:
        context.push(AppRoutes.profile);
      default:
        mostrarProximamente(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.transparent
                : theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _inicio,
        onTap: (indice) => _irA(context, indice),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: theme.colorScheme.onSurface,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            label: 'Tarjetas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tu cuenta',
          ),
        ],
      ),
    );
  }
}
