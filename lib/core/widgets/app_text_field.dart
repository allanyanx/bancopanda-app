import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Campo de texto de BancoPanda. Con `isPassword: true` oculta el texto
/// y muestra el ícono del ojo para verlo.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool isPassword;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Estado efímero de la vista: no le interesa a ningún ViewModel.
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      obscureText: widget.isPassword && _oculto,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // El campo es claro en ambos modos, así que el texto siempre es oscuro.
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _oculto ? 'Mostrar contraseña' : 'Ocultar contraseña',
                icon: Icon(
                  _oculto
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _oculto = !_oculto),
              )
            : null,
      ),
    );
  }
}
