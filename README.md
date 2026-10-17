# 🐼 BancoPanda App

App móvil de banca de BancoPanda hecha con **Flutter**. Consume la API REST de [bancopanda-api](https://github.com/allanyanx/bancopanda-api).

## Funcionalidades

- **Bienvenida, login y registro** con nombre de usuario (sesión con token JWT guardada de forma segura).
- **Inicio (dashboard)**: saldo total (se puede ocultar con el ojito), cuentas, tarjetas y actividad reciente.
- **Transferir**: a cuentas de Banco Panda o de otros bancos del país (banco, cuenta y cédula), con beneficiarios frecuentes, confirmación y comprobante.
- **Efectivo móvil**: retiro sin tarjeta; genera dos códigos de 4 dígitos para el cajero, con el celular registrado o con otro número.
- **Pagar servicios**: agua, luz e internet (por ahora solo visual).
- **Recibir dinero**: aviso de "Próximamente".
- **Mis tarjetas**: número completo, titular, vencimiento, estado y cuenta asociada.
- **Movimientos**: los últimos 50 de todas las cuentas.
- **Perfil**: datos personales, cambio de contraseña, preferencias y modo oscuro.

## Arquitectura

**Feature-first + MVVM.** Cada funcionalidad tiene su carpeta en `lib/features/` y, dentro, las mismas capas:

| Capa | Carpeta | Qué hace |
|---|---|---|
| View | `view/` | Pantallas y widgets. Solo dibujan y avisan lo que toca el usuario |
| ViewModel | `viewmodel/` | Estado de la pantalla (`cargando`, `error`, datos) y reglas; avisa con `notifyListeners()` |
| Repository | `data/repositories/` | Intermediario entre el ViewModel y la fuente de datos |
| DataSource | `data/datasources/` | Llama a la API (rutas y JSON) usando `ApiClient` |
| Model | `model/` | Clases de datos con `fromJson` / `toJson` |

```
lib/
├── main.dart                 # Arranca la app con los providers
├── app.dart                  # MaterialApp: tema claro/oscuro y router
├── core/                     # Lo que comparten todas las funcionalidades
│   ├── config/               # Dirección del servidor (configurable desde el login)
│   ├── di/providers.dart     # Crea los repositorios y ViewModels globales
│   ├── network/api_client.dart  # HTTP + token + mensajes de error en español
│   ├── router/app_router.dart   # Rutas (go_router) y protección por sesión
│   ├── storage/              # Almacenamiento seguro (token, preferencias)
│   ├── theme/                # Colores (app_colors.dart) y tema (app_theme.dart)
│   ├── utils/                # Validaciones, formatos, celular, id anti-duplicados
│   └── widgets/              # Botón, campo de texto, diálogos, filas de detalle
└── features/
    ├── auth/                 # Bienvenida, login y registro
    ├── dashboard/            # Inicio y movimientos
    ├── transfers/            # Transferir (5 pasos)
    ├── mobile_cash/          # Efectivo móvil (formulario y códigos)
    ├── services/             # Pagar servicios
    ├── cards/                # Mis tarjetas
    ├── profile/              # Perfil y seguridad
    └── settings/             # Configurar servidor
```

### Paquetes principales

| Paquete | Para qué |
|---|---|
| `provider` | Conectar ViewModels con las pantallas (MVVM) |
| `go_router` | Navegación entre pantallas |
| `http` | Llamadas a la API |
| `flutter_secure_storage` | Guardar el token y preferencias de forma segura |
| `intl` | Formato de dinero (`$1,234.56`) |
| `google_fonts` | Fuente Poppins |

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) estable (probado con 3.47)
- La API corriendo (local o en Render)

## Ejecutar

```bash
flutter pub get
```

```bash
flutter run
```

Con `-d windows`, `-d chrome` o con un emulador de Android abierto.

### Elegir el servidor

Por defecto la app usa la API publicada en Render (`https://bancopanda-api.onrender.com`). Para usar la API local, en el login toca el **engranaje ⚙** y escribe:

| Dónde corre la app | Dirección |
|---|---|
| Windows o Chrome | `http://localhost:5258` |
| Emulador de Android | `http://10.0.2.2:5258` |
| Celular en la misma red Wi-Fi | `http://IP-de-tu-PC:5258` (la API debe arrancar con `dotnet run --urls http://0.0.0.0:5258`) |

### Usuarios de prueba

Se crean con `Database/seed.sql` del repositorio de la API (contraseña `Panda2026`):

| Usuario | Cuentas | Celular |
|---|---|---|
| `andrea.demo` | `5000900001` (ahorros), `5000900002` (corriente) | +593 987654321 |
| `carlos.demo` | `5000900003` (ahorros) | +593 991234567 |

## Tests

```bash
flutter test
```

Prueban los ViewModels (con data sources falsos en `test/helpers/`), las validaciones, los formatos y la lectura del JSON. Los 2 tests de `test/core/api_client_test.dart` esperan la dirección antigua `http://10.0.2.2:5258` y fallan desde que la app arranca apuntando a Render.

## Colores

La paleta está en `lib/core/theme/app_colors.dart` (verde principal `#239A55`). El ícono y la pantalla de carga usan los colores de `pubspec.yaml` (`flutter_launcher_icons` y `flutter_native_splash`).
