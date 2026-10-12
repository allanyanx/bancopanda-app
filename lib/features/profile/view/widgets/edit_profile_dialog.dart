import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/model/usuario.dart';
import '../../model/datos_perfil.dart';
import '../../viewmodel/profile_view_model.dart';

Future<void> mostrarEditarPerfil(BuildContext context, Usuario usuario) {
  context.read<ProfileViewModel>().clearError();
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => EditProfileDialog(usuario: usuario),
  );
}

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nombres = TextEditingController(text: widget.usuario.nombres);
  late final _apellidos = TextEditingController(text: widget.usuario.apellidos);
  late final _correo = TextEditingController(text: widget.usuario.correo);
  late final _telefono = TextEditingController(
    text: widget.usuario.telefono ?? '',
  );
  final _contrasenaActual = TextEditingController();
  final _contrasenaNueva = TextEditingController();
  final _confirmacion = TextEditingController();

  bool get _cambiaContrasena => _contrasenaNueva.text.isNotEmpty;

  @override
  void dispose() {
    for (final controller in [
      _nombres,
      _apellidos,
      _correo,
      _telefono,
      _contrasenaActual,
      _contrasenaNueva,
      _confirmacion,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<ProfileViewModel>();

    final ok = await vm.save(
      DatosPerfil(
        nombres: _nombres.text.trim(),
        apellidos: _apellidos.text.trim(),
        correo: _correo.text.trim(),
        telefono: _telefono.text.trim(),
        contrasenaActual: _cambiaContrasena ? _contrasenaActual.text : null,
        contrasenaNueva: _cambiaContrasena ? _contrasenaNueva.text : null,
      ),
    );

    if (!mounted) return;

    final sesionCerrada = vm.usuario == null;
    if (!ok && !sesionCerrada) return;

    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();

    if (ok) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Campo(
                label: 'Nombres',
                controller: _nombres,
                validator: Validators.nombres,
              ),
              const SizedBox(height: 12),
              _Campo(
                label: 'Apellidos',
                controller: _apellidos,
                validator: Validators.apellidos,
              ),
              const SizedBox(height: 12),
              _Campo(
                label: 'Correo',
                controller: _correo,
                validator: Validators.correo,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _Campo(
                label: 'Número de teléfono',
                controller: _telefono,
                validator: Validators.telefono,
                keyboardType: TextInputType.phone,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 12),
              _Campo(
                label: 'Nueva contraseña (opcional)',
                controller: _contrasenaNueva,
                isPassword: true,
                onChanged: (_) => setState(() {}),
                validator: (value) => (value == null || value.isEmpty)
                    ? null
                    : Validators.contrasena(value),
              ),
              if (_cambiaContrasena) ...[
                const SizedBox(height: 12),
                _Campo(
                  label: 'Confirmar nueva contraseña',
                  controller: _confirmacion,
                  isPassword: true,
                  validator: (value) => Validators.confirmarContrasena(
                    value,
                    _contrasenaNueva.text,
                  ),
                ),
                const SizedBox(height: 12),
                _Campo(
                  label: 'Contraseña actual',
                  controller: _contrasenaActual,
                  isPassword: true,
                  validator: Validators.contrasenaLogin,
                ),
              ],
              if (vm.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  vm.error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: vm.isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: vm.isSaving ? null : _guardar,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: vm.isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  const _Campo({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.formatters,
    this.onChanged,
    this.isPassword = false,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final ValueChanged<String>? onChanged;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      onChanged: onChanged,
      obscureText: isPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
