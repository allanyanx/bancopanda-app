import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_settings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class ServerSettingsScreen extends StatefulWidget {
  const ServerSettingsScreen({super.key});

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _url;

  @override
  void initState() {
    super.initState();
    _url = TextEditingController(text: context.read<AppSettings>().serverUrl);
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<AppSettings>().setServerUrl(_url.text);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dirección del servidor guardada')),
    );
    context.pop();
  }

  Future<void> _reset() async {
    await context.read<AppSettings>().resetServerUrl();
    _url.text = AppSettings.defaultServerUrl;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundAuth,
      appBar: AppBar(
        title: const Text('Configurar servidor'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Dirección del backend',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'http://10.0.2.2:5258',
                  icon: Icons.dns_outlined,
                  controller: _url,
                  validator: Validators.urlServidor,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                ),
                const SizedBox(height: 16),
                Text(
                  '• Emulador de Android: http://10.0.2.2:5258\n'
                  '• Celular en la misma red Wi-Fi: http://IP-de-tu-PC:5258',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                AppButton(label: 'Guardar', onPressed: _save),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Restablecer valor por defecto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
