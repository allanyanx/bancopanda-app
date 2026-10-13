import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/proximamente.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../viewmodel/auth_view_model.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_messages.dart';
import 'widgets/auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identificador = TextEditingController();
  final _contrasena = TextEditingController();

  @override
  void dispose() {
    _identificador.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    await context.read<AuthViewModel>().login(
          identificador: _identificador.text.trim(),
          contrasena: _contrasena.text,
        );
  }

  void _goTo(String route) {
    context.read<AuthViewModel>().clearError();
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return AuthScaffold(
      action: IconButton(
        tooltip: 'Configurar servidor',
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => _goTo(AppRoutes.serverSettings),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(),
            const SizedBox(height: 40),
            Text(
              'Ingresa a tu banca móvil',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 28),
            AppTextField(
              hint: 'Correo electrónico o cédula',
              icon: Icons.person_outline,
              controller: _identificador,
              validator: Validators.correoOCedula,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Contraseña',
              icon: Icons.lock_outline,
              controller: _contrasena,
              validator: Validators.contrasenaLogin,
              isPassword: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            if (auth.error != null) ...[
              const SizedBox(height: 16),
              AuthErrorMessage(auth.error!),
            ],
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButton(
                label: 'Iniciar Sesión',
                isLoading: auth.isLoading,
                onPressed: _submit,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => mostrarProximamente(context),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
            AuthFooterLink(
              question: '¿Eres nuevo?',
              action: 'Regístrate aquí',
              onTap: () => _goTo(AppRoutes.register),
            ),
          ],
        ),
      ),
    );
  }
}
