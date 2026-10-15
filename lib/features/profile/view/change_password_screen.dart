import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/proximamente.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../model/cambio_contrasena.dart';
import '../viewmodel/profile_view_model.dart';
import 'widgets/profile_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _actual = TextEditingController();
  final _nueva = TextEditingController();
  final _confirmacion = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileViewModel>().limpiarError();
    });
  }

  @override
  void dispose() {
    for (final c in [_actual, _nueva, _confirmacion]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _actualizar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<ProfileViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await vm.cambiarContrasena(
      CambioContrasena(actual: _actual.text, nueva: _nueva.text),
    );

    if (!mounted || !ok) return;
    context.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Contraseña actualizada'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cambio de contraseña'),
        actions: [
          IconButton(
            tooltip: 'Cerrar',
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ProfileField(
                          label: 'Contraseña actual',
                          controller: _actual,
                          isPassword: true,
                          validator: Validators.contrasenaLogin,
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          label: 'Contraseña nueva',
                          controller: _nueva,
                          isPassword: true,
                          validator: Validators.contrasena,
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          label: 'Confirmar contraseña nueva',
                          controller: _confirmacion,
                          isPassword: true,
                          validator: (v) =>
                              Validators.confirmarContrasena(v, _nueva.text),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => mostrarProximamente(context),
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                        if (vm.error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            vm.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppButton(
                  label: 'Actualizar',
                  isLoading: vm.guardando,
                  onPressed: _actualizar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
