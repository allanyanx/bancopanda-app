import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/celular.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../model/datos_perfil.dart';
import '../viewmodel/profile_view_model.dart';
import 'widgets/profile_field.dart';
import 'widgets/profile_header.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuario = TextEditingController();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();

  bool _editando = false;
  int _version = 0;

  @override
  void initState() {
    super.initState();
    _restaurar();
  }

  void _restaurar() {
    final u = context.read<ProfileViewModel>().usuario;
    if (u == null) return;
    _usuario.text = u.nombreUsuario;
    _nombres.text = u.nombres;
    _apellidos.text = u.apellidos;
    _correo.text = u.correo;
    _telefono.text = Celular.local(u.telefono);
  }

  @override
  void dispose() {
    for (final c in [_usuario, _nombres, _apellidos, _correo, _telefono]) {
      c.dispose();
    }
    super.dispose();
  }

  void _alternarEdicion() {
    final vm = context.read<ProfileViewModel>();
    vm.limpiarError();
    setState(() {
      if (_editando) _restaurar();
      _editando = !_editando;
      _version++;
    });
  }

  Future<void> _actualizar() async {
    FocusScope.of(context).unfocus();

    final vm = context.read<ProfileViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final datos = DatosPerfil(
      nombreUsuario: _usuario.text.trim(),
      nombres: _nombres.text.trim(),
      apellidos: _apellidos.text.trim(),
      correo: _correo.text.trim(),
      telefono: Celular.completo(_telefono.text),
    );

    if (!vm.hayCambios(datos)) {
      setState(() {
        _editando = false;
        _version++;
      });
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('No hay cambios para guardar'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final ok = await vm.guardar(datos);

    if (!mounted || !ok) return;
    _restaurar();
    setState(() {
      _editando = false;
      _version++;
    });
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final usuario = vm.usuario;
    if (usuario == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final titulo = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.brightness == Brightness.dark
          ? AppColors.primary
          : AppColors.primaryDark,
    );
    final soloLectura = !_editando;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              key: ValueKey(_version),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: 'Volver',
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => context.pop(),
                  ),
                ),
                Center(child: ProfileHeader(usuario: usuario)),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Datos Personales', style: titulo),
                    TextButton(
                      onPressed: vm.guardando ? null : _alternarEdicion,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: Text(_editando ? 'Cancelar' : 'Editar'),
                    ),
                  ],
                ),
                ProfileField(
                  label: 'Usuario',
                  controller: _usuario,
                  readOnly: soloLectura,
                  validator: Validators.nombreUsuario,
                  formatters: InputFormatters.nombreUsuario,
                ),
                const SizedBox(height: 10),
                ProfileField(
                  label: 'Nombres',
                  controller: _nombres,
                  readOnly: soloLectura,
                  validator: Validators.nombres,
                  formatters: InputFormatters.soloLetras,
                ),
                const SizedBox(height: 10),
                ProfileField(
                  label: 'Apellidos',
                  controller: _apellidos,
                  readOnly: soloLectura,
                  validator: Validators.apellidos,
                  formatters: InputFormatters.soloLetras,
                ),
                const SizedBox(height: 10),
                ProfileField(
                  label: 'Correo',
                  controller: _correo,
                  readOnly: soloLectura,
                  validator: Validators.correo,
                  keyboardType: TextInputType.emailAddress,
                  formatters: InputFormatters.correo,
                ),
                const SizedBox(height: 10),
                ProfileField(
                  label: 'Número de celular',
                  controller: _telefono,
                  readOnly: soloLectura,
                  prefixText: Celular.prefijo,
                  validator: Validators.celular,
                  keyboardType: TextInputType.phone,
                  formatters: InputFormatters.celular,
                ),
                if (_editando) ...[
                  if (vm.error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      vm.error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      label: 'Actualizar',
                      isLoading: vm.guardando,
                      onPressed: _actualizar,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
