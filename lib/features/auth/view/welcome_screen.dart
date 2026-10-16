import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodel/auth_view_model.dart';
import 'widgets/auth_header.dart';

/// Se muestra siempre al abrir la app. Con sesión guardada saluda por el
/// nombre y pasa al home; sin sesión da la bienvenida y pasa al login.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  static const _duracion = Duration(milliseconds: 2500);

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
    curve: const Interval(0, 0.2, curve: Curves.easeOut),
  );
  late final Animation<double> _crece = Tween(begin: 0.4, end: 1.0).animate(
    CurvedAnimation(
      parent: _total,
      curve: const Interval(0, 0.35, curve: Curves.elasticOut),
    ),
  );
  late final Animation<double> _latido = Tween(
    begin: 1.0,
    end: 1.04,
  ).animate(CurvedAnimation(parent: _pulso, curve: Curves.easeInOut));
  late final Animation<double> _saludo = CurvedAnimation(
    parent: _total,
    curve: const Interval(0.25, 0.5, curve: Curves.easeOut),
  );

  bool _sesionLista = false;

  @override
  void initState() {
    super.initState();
    _pulso.repeat(reverse: true);
    _iniciar();
  }

  Future<void> _iniciar() async {
    final auth = context.read<AuthViewModel>();

    await Future.wait([
      _total.forward(),
      auth.restoreSession().catchError((_) {}).whenComplete(() {
        if (mounted) setState(() => _sesionLista = true);
      }),
    ]);

    if (!mounted) return;
    context.go(auth.isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }

  @override
  void dispose() {
    _total.dispose();
    _pulso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final nombre = context.watch<AuthViewModel>().usuario?.primerNombre ?? '';

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundAuth,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo + nombre + frase, centrados, con latido suave.
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
              const SizedBox(height: 32),

              // Saludo: ¡Hola, Nombre! con sesión, ¡Bienvenido! sin sesión.
              FadeTransition(
                opacity: _saludo,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(_saludo),
                  child: AnimatedOpacity(
                    opacity: _sesionLista ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Text.rich(
                      TextSpan(
                        text: nombre.isEmpty ? '¡Bienvenido!' : '¡Hola, ',
                        children: nombre.isEmpty
                            ? null
                            : [
                                TextSpan(
                                  text: nombre,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const TextSpan(text: '!'),
                              ],
                      ),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
