class CambioContrasena {
  const CambioContrasena({required this.actual, required this.nueva});

  final String actual;
  final String nueva;

  Map<String, dynamic> toJson() => {
    'contrasenaActual': actual,
    'contrasenaNueva': nueva,
  };
}
