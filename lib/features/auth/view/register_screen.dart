import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../model/datos_registro.dart';
import '../viewmodel/auth_view_model.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_messages.dart';
import 'widgets/auth_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final _soloDiezDigitos = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  final _formKey = GlobalKey<FormState>();
  final _cedula = TextEditingController();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();
  final _contrasena = TextEditingController();
  final _confirmacion = TextEditingController();

  bool _aceptaTerminos = false;
  bool _faltanTerminos = false;

  @override
  void dispose() {
    for (final controller in [
      _cedula,
      _nombres,
      _apellidos,
      _correo,
      _telefono,
      _contrasena,
      _confirmacion,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final formularioValido = _formKey.currentState!.validate();
    setState(() => _faltanTerminos = !_aceptaTerminos);
    if (!formularioValido || !_aceptaTerminos) return;

    // Al registrarse el backend devuelve la sesión iniciada y el router
    // redirige al inicio automáticamente.
    await context.read<AuthViewModel>().register(
          DatosRegistro(
            cedula: _cedula.text.trim(),
            nombres: _nombres.text.trim(),
            apellidos: _apellidos.text.trim(),
            correo: _correo.text.trim(),
            telefono: _telefono.text.trim(),
            contrasena: _contrasena.text,
            aceptaTerminos: _aceptaTerminos,
          ),
        );
  }

  void _goToLogin() {
    context.read<AuthViewModel>().clearError();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader.horizontal(),
            const SizedBox(height: 20),
            Text(
              '¡Únete al mejor banco!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Abre tu cuenta de forma fácil y segura',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.primary : AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 28),
            AppTextField(
              hint: 'Cédula',
              icon: Icons.badge_outlined,
              controller: _cedula,
              validator: Validators.cedula,
              keyboardType: TextInputType.number,
              inputFormatters: _soloDiezDigitos,
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Nombres',
              icon: Icons.person_outline,
              controller: _nombres,
              validator: Validators.nombres,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Apellidos',
              icon: Icons.person_outline,
              controller: _apellidos,
              validator: Validators.apellidos,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Correo electrónico',
              icon: Icons.mail_outline,
              controller: _correo,
              validator: Validators.correo,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Número de teléfono',
              icon: Icons.phone_outlined,
              controller: _telefono,
              validator: Validators.telefono,
              keyboardType: TextInputType.phone,
              inputFormatters: _soloDiezDigitos,
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Contraseña',
              icon: Icons.lock_outline,
              controller: _contrasena,
              validator: Validators.contrasena,
              isPassword: true,
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Confirmar contraseña',
              icon: Icons.lock_outline,
              controller: _confirmacion,
              validator: (value) =>
                  Validators.confirmarContrasena(value, _contrasena.text),
              isPassword: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 4),
            CheckboxListTile(
              value: _aceptaTerminos,
              onChanged: (value) => setState(() {
                _aceptaTerminos = value ?? false;
                _faltanTerminos = false;
              }),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Acepto los Términos y Condiciones',
                style: theme.textTheme.bodyMedium,
              ),
              subtitle: _faltanTerminos
                  ? Text(
                      'Debes aceptar los términos para continuar',
                      style: TextStyle(color: theme.colorScheme.error),
                    )
                  : null,
            ),
            if (auth.error != null) ...[
              const SizedBox(height: 8),
              AuthErrorMessage(auth.error!),
            ],
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButton(
                label: 'Crear Cuenta',
                isLoading: auth.isLoading,
                onPressed: _submit,
              ),
            ),
            const SizedBox(height: 12),
            AuthFooterLink(
              question: '¿Ya tienes cuenta?',
              action: 'Inicia sesión',
              onTap: _goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}
