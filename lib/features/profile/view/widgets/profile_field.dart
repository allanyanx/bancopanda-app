import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Campo del perfil: la etiqueta se queda fija arriba y el valor va debajo.
/// En modo lectura (readOnly) se ve como una tarjeta; en edición se resalta el borde.
class ProfileField extends StatefulWidget {
  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.validator,
    this.keyboardType,
    this.formatters,
    this.isPassword = false,
    this.prefixText,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final bool isPassword;
  final String? prefixText;

  @override
  State<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(20),
        border: widget.readOnly
            ? Border.all(color: Colors.transparent, width: 1.2)
            : Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              readOnly: widget.readOnly,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatters,
              obscureText: widget.isPassword && _oculto,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: widget.label,
                prefixText: widget.prefixText,
                prefixStyle: const TextStyle(color: AppColors.textPrimary),
                // La etiqueta nunca se mueve: siempre queda arriba.
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                floatingLabelStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                filled: false,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
          if (widget.isPassword)
            IconButton(
              icon: Icon(
                _oculto
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _oculto = !_oculto),
            ),
        ],
      ),
    );
  }
}
