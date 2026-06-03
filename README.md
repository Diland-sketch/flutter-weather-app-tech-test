# Weather App

Aplicación móvil desarrollada en Flutter como prueba técnica para vacante de Flutter Developer. Consume la API de [VisualCrossing Timeline Weather](https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/) para mostrar eventos climáticos y el pronóstico de los últimos 5 días basado en la ubicación del usuario.

---

## Tabla de contenidos

- [Características](#características)
- [Arquitectura](#arquitectura)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Tecnologías y dependencias](#tecnologías-y-dependencias)
- [Requisitos previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración de flavors](#configuración-de-flavors)
- [Ejecución](#ejecución)
- [Variables de entorno y API Key](#variables-de-entorno-y-api-key)
- [Estado del proyecto](#estado-del-proyecto)

---

## Características

- **Eventos climáticos** — lista y detalle de eventos como granizo, tornados, vientos y terremotos, basados en la ubicación del usuario.
- **Clima últimos 5 días** — condición actual y pronóstico diario de los últimos 5 días.
- **Geolocalización** — detección automática de la ubicación del dispositivo con opción de ingreso manual de ciudad.
- **Favoritos** — el usuario puede agregar y eliminar eventos favoritos, persistidos localmente con Realm. El estado se propaga reactivamente con Riverpod.
- **Modo offline** — detección de conectividad en tiempo real. Sin conexión, la app notifica al usuario y muestra la última información cacheada.
- **Vista de mapa** — coordenadas de eventos presentadas en un mapa interactivo con Flutter Map y OpenStreetMap.
- **Flavors Dev / Prod** — dos ambientes con nombre de app, ícono y configuración diferenciados, disponibles en Android e iOS.
- **Idioma español y sistema métrico** — toda la información se presenta en español con unidades métricas (°C, km/h).

---

## Arquitectura

La aplicación implementa una **Clean Architecture simplificada**, organizada por features (Feature-First). Se omitió la capa de Use Cases de forma consciente: la lógica de negocio de esta aplicación reside íntegramente en los repositorios y no justifica una capa adicional para este alcance.

```
Presentation  →  Domain  →  Data
(Riverpod)       (Entities    (DTOs · DataSources ·
                  + Repos)     RepoImpl · Realm)
```

Para un análisis detallado de las decisiones técnicas, consulta [`docs/architecture.md`](docs/architecture.md).

### Principios aplicados

- **Separación de responsabilidades** — cada capa conoce solo la que tiene debajo de ella.
- **Inversión de dependencias** — la presentación y los datos dependen de interfaces del dominio, no de implementaciones concretas.
- **Inmutabilidad del estado** — las entidades usan `copyWith` y Riverpod gestiona el estado con `AsyncNotifier`.
- **Manejo de errores tipado** — se usa `Either<Failure, T>` de `fpdart` en lugar de excepciones no controladas.

---

## Estructura del proyecto

```
lib/
├── core/
│   ├── config/          # FlavorConfig · AppConfig
│   ├── constants/       # ApiConstants
│   ├── errors/          # AppException · Failure (sealed class)
│   ├── network/         # ApiClient (Dio) · ConnectivityService
│   ├── storage/         # RealmDb (inicialización y singleton)
│   ├── theme/           # AppTheme
│   └── utils/           # DateFormatter
│
├── features/
│   ├── weather/         # Pantalla últimos 5 días
│   │   ├── data/        # WeatherRemoteDS · WeatherLocalDS · WeatherRepoImpl
│   │   ├── domain/      # WeatherEntity · DayForecastEntity · IWeatherRepository
│   │   └── presentation/# WeatherNotifier · WeatherScreen · widgets
│   │
│   ├── events/          # Pantalla de eventos climáticos
│   │   ├── data/
│   │   ├── domain/      # EventEntity · IEventsRepository
│   │   └── presentation/# EventsScreen · EventDetailScreen
│   │
│   ├── favorites/       # Gestión de favoritos con persistencia
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/# FavoritesNotifier · FavoritesScreen
│   │
│   ├── location/        # Geolocalización y búsqueda manual
│   │   ├── data/        # LocationService
│   │   ├── domain/      # LocationEntity
│   │   └── presentation/# LocationProvider
│   │
│   └── map/             # Vista de mapa con coordenadas
│       └── presentation/# MapScreen
│
├── app.dart             # MaterialApp + GoRouter
├── main_dev.dart        # Entry point — flavor dev
└── main_prod.dart       # Entry point — flavor prod

assets/
├── icons/               # Íconos por flavor
└── images/              # Recursos gráficos compartidos

docs/
└── architecture.md      # Documentación extendida de arquitectura
```

---

## Tecnologías y dependencias

| Categoría | Paquete | Versión | Propósito |
|---|---|---|---|
| Estado / DI | `flutter_riverpod` | ^2.5.1 | Gestión de estado reactivo |
| Estado / DI | `riverpod_annotation` | ^2.3.5 | Code generation para providers |
| Navegación | `go_router` | ^13.2.0 | Routing declarativo |
| Red | `dio` | ^5.4.3 | Cliente HTTP con interceptores |
| Red | `connectivity_plus` | ^6.0.3 | Detección de conectividad |
| Persistencia | `realm` | ^20.0.0 | Base de datos local (offline + favoritos) |
| Ubicación | `geolocator` | ^11.0.0 | GPS del dispositivo |
| Ubicación | `geocoding` | ^3.0.0 | Conversión coordenadas ↔ nombre de ciudad |
| Mapas | `flutter_map` | ^6.1.0 | Mapa interactivo con OpenStreetMap |
| Mapas | `latlong2` | ^0.9.0 | Tipos de coordenadas |
| Errores | `fpdart` | ^1.1.0 | `Either<Failure, T>` para manejo funcional |
| Utilidades | `intl` | ^0.19.0 | Fechas en español |
| Utilidades | `uuid` | ^4.3.3 | IDs únicos para entidades |
| UI | `cached_network_image` | ^3.3.1 | Imágenes con caché |

**Dev dependencies:** `build_runner`, `riverpod_generator`, `realm_generator`, `mocktail`, `flutter_lints`, `riverpod_lint`, `flutter_launcher_icons`.

---

## Requisitos previos

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio o VS Code con extensión Flutter
- Xcode 15+ (solo para compilar en iOS, requiere macOS)
- API key gratuita de [VisualCrossing](https://www.visualcrossing.com/sign-up)

Verificar instalación:

```bash
flutter doctor
```

---

## Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/Diland-sketch/flutter-weather-app-tech-test.git
cd weather_app

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar el generador de código (Riverpod + Realm)
dart run build_runner build --delete-conflicting-outputs
```

---

## Configuración de flavors

La aplicación tiene dos ambientes configurados: **dev** y **prod**. Cada uno tiene nombre de app, ícono y API key diferenciados.

### Android

La configuración está en `android/app/build.gradle`:

```groovy
flavorDimensions "environment"

productFlavors {
    dev {
        dimension "environment"
        applicationIdSuffix ".dev"
        versionNameSuffix "-dev"
        resValue "string", "app_name", "Weather Dev"
    }
    prod {
        dimension "environment"
        resValue "string", "app_name", "Weather"
    }
}
```

Los íconos por flavor se ubican en:

```
android/app/src/dev/res/mipmap-*/   ← ícono con badge DEV
android/app/src/prod/res/mipmap-*/  ← ícono de producción
```

### iOS

En iOS los flavors se implementan como **Schemes y Build Configurations** en Xcode.

**Pasos para configurar:**

1. Abrir `ios/Runner.xcworkspace` en Xcode.
2. Ir a `Product → Scheme → Manage Schemes`.
3. Duplicar el scheme `Runner` y renombrarlo `dev`.
4. Duplicar nuevamente y renombrarlo `prod`.
5. En cada scheme, editar `Edit Scheme → Run → Build Configuration`:
   - `dev` → `Debug-dev` / `Release-dev`
   - `prod` → `Debug-prod` / `Release-prod`
6. En `Build Settings`, agregar la variable `FLUTTER_TARGET` por configuración:
   - `Debug-dev` y `Release-dev` → `lib/main_dev.dart`
   - `Debug-prod` y `Release-prod` → `lib/main_prod.dart`
7. Agregar la variable `APP_NAME` en `Build Settings`:
   - `dev` → `Weather Dev`
   - `prod` → `Weather`
8. En `ios/Runner/Info.plist`, reemplazar el valor de `CFBundleName`:

```xml
<key>CFBundleName</key>
<string>$(APP_NAME)</string>
```

**Generar íconos por flavor:**

```bash
dart run flutter_launcher_icons -f flutter_launcher_icons_dev.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons_prod.yaml
```

---

## Ejecución

```bash
# Flavor dev (desarrollo)
flutter run --flavor dev -t lib/main_dev.dart

# Flavor prod (producción)
flutter run --flavor prod -t lib/main_prod.dart

# Build APK — producción
flutter build apk --flavor prod -t lib/main_prod.dart --release

# Build IPA — producción (requiere macOS + Xcode)
flutter build ipa --flavor prod -t lib/main_prod.dart
```

---

## Variables de entorno y API Key

La API key de VisualCrossing se configura directamente en los entry points por flavor:

- `lib/main_dev.dart` → `apiKey: 'dev-api-key'`
- `lib/main_prod.dart` → `apiKey: 'prod-api-key'`

> **Nota de seguridad:** Para un proyecto en producción real, la API key se pasaría mediante `--dart-define` en tiempo de compilación y nunca se incluiría en el código fuente. Para esta prueba técnica se mantiene en los entry points por simplicidad y trazabilidad.

Ejemplo con `--dart-define` (implementación futura):

```bash
flutter run --flavor dev -t lib/main_dev.dart \
  --dart-define=API_KEY=tu_api_key_aqui
```

---

## Estado del proyecto

| Módulo | Estado |
|---|---|
| Configuración del proyecto | ✅ Completo |
| Estructura de carpetas | ✅ Completo |
| Flavors Android | ✅ Completo |
| Flavors iOS | 🔧 Configuración documentada |
| `pubspec.yaml` y dependencias | ✅ Completo |
| Análisis estático (`analysis_options.yaml`) | ✅ Completo |
| Inicialización de Realm | ✅ Completo |
| Capa de red (Dio + interceptores) | 🚧 En desarrollo |
| Pantalla últimos 5 días | 🚧 En desarrollo |
| Pantalla eventos | 🚧 En desarrollo |
| Favoritos con Riverpod | 🚧 En desarrollo |
| Modo offline | 🚧 En desarrollo |
| Vista de mapa | 🚧 En desarrollo |
| Tests unitarios | 🚧 En desarrollo |

---

## Autor

Desarrollado por **[Diland López]**