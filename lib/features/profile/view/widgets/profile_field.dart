import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Campo del perfil: la etiqueta va fija arriba y el valor debajo.
/// En modo lectura se ve como tarjeta; en edición se resalta el borde.
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
    final base = Theme.of(context).textTheme.bodyLarge;
    final estiloTexto = base?.copyWith(
      color: AppColors.textPrimary,
      fontSize: 16,
    );
    final estiloEtiqueta = base?.copyWith(
      color: AppColors.textSecondary,
      fontSize: 14,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.readOnly ? Colors.transparent : AppColors.primary,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, style: estiloEtiqueta),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (widget.prefixText != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(widget.prefixText!, style: estiloTexto),
                      ),
                    Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        readOnly: widget.readOnly,
                        validator: widget.validator,
                        keyboardType: widget.keyboardType,
                        inputFormatters: widget.formatters,
                        obscureText: widget.isPassword && _oculto,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: estiloTexto,
                        decoration: const InputDecoration(
                          isDense: true,
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.isPassword)
            IconButton(
              tooltip: _oculto ? 'Mostrar contraseña' : 'Ocultar contraseña',
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
