import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodel/auth_view_model.dart';
import 'widgets/auth_header.dart';

/// Se muestra después de iniciar sesión o registrarse, y luego pasa al dashboard.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  static const _duracion = Duration(seconds: 3);

  static const _frases = [
    'Iniciando tu sesión segura...',
    'Preparando tus cuentas...',
    'Cargando tus movimientos...',
    '¡Casi listo!',
  ];

  late final AnimationController _total = AnimationController(
    vsync: this,
    duration: _duracion,
  );
  late final AnimationController _pulso = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  late final Animation<double> _aparece = CurvedAnimation(
    parent: _total,
    curve: const Interval(0, 0.08, curve: Curves.easeOut),
  );
  late final Animation<double> _crece = Tween(begin: 0.4, end: 1.0).animate(
    CurvedAnimation(
      parent: _total,
      curve: const Interval(0, 0.15, curve: Curves.elasticOut),
    ),
  );
  late final Animation<double> _latido = Tween(
    begin: 1.0,
    end: 1.05,
  ).animate(CurvedAnimation(parent: _pulso, curve: Curves.easeInOut));
  late final Animation<double> _saludo = CurvedAnimation(
    parent: _total,
    curve: const Interval(0.12, 0.24, curve: Curves.easeOut),
  );

  bool _salio = false;

  @override
  void initState() {
    super.initState();
    _pulso.repeat(reverse: true);
    _total.addStatusListener((estado) {
      if (estado == AnimationStatus.completed) _continuar();
    });
    _total.forward();
  }

  @override
  void dispose() {
    _total.dispose();
    _pulso.dispose();
    super.dispose();
  }

  void _continuar() {
    if (_salio || !mounted) return;
    _salio = true;
    context.read<AuthViewModel>().terminarBienvenida();
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final nombre = context.read<AuthViewModel>().usuario?.primerNombre ?? '';

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundAuth,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _continuar, // tocar la pantalla la omite
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Aro que late detrás del logo
                  AnimatedBuilder(
                    animation: _pulso,
                    builder: (context, _) => Container(
                      width: 230 + 40 * _pulso.value,
                      height: 230 + 40 * _pulso.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(
                          alpha: 0.10 + 0.05 * (1 - _pulso.value),
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _aparece,
                    child: ScaleTransition(
                      scale: _crece,
                      child: ScaleTransition(
                        scale: _latido,
                        child: const AuthHeader(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _saludo,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(_saludo),
                  child: Text.rich(
                    TextSpan(
                      text: '¡Hola, ',
                      children: [
                        TextSpan(
                          text: nombre,
                          style: const TextStyle(color: AppColors.primary),
                        ),
                        const TextSpan(text: '!'),
                      ],
                    ),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: _total,
                builder: (context, _) {
                  final i = (_total.value * _frases.length).floor().clamp(
                    0,
                    _frases.length - 1,
                  );
                  return Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _frases[i],
                          key: ValueKey(i),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 56),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _total.value,
                            minHeight: 6,
                            color: AppColors.primary,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),
              Text(
                'Toca para omitir',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
