# Arquitectura de la Solución

## Objetivo

La aplicación fue diseñada para cumplir los requerimientos de la prueba técnica de Flutter priorizando mantenibilidad, escalabilidad y rapidez de desarrollo, evitando sobreingeniería innecesaria para un proyecto de duración limitada.

---

# Decisión Arquitectónica

Se seleccionó una variante simplificada de Clean Architecture combinada con una organización Feature-First.

La estructura general se basa en:

Presentation → Domain → Data

A diferencia de una implementación estricta de Clean Architecture, se decidió omitir la capa de Use Cases debido a que la lógica de negocio del proyecto es relativamente sencilla y se concentra principalmente en:

* Consumo de APIs externas.
* Persistencia local.
* Gestión de favoritos.
* Manejo de conectividad.
* Presentación de datos climáticos.

Esta decisión reduce complejidad y cantidad de código sin sacrificar mantenibilidad ni separación de responsabilidades.

---

# Organización por Features

La aplicación está organizada por funcionalidades (Feature-First) en lugar de una estructura Layer-First.

Cada módulo contiene sus propias capas:

* Presentation
* Domain
* Data

Principales módulos:

* Weather
* Events
* Favorites
* Location
* Map

Esta organización facilita la escalabilidad y el mantenimiento, ya que todo el código relacionado con una funcionalidad se encuentra agrupado.

---

# Capa Presentation

Responsabilidades:

* Pantallas.
* Widgets.
* Navegación.
* Gestión de estado mediante Riverpod.

La capa de presentación no conoce detalles de implementación de APIs ni almacenamiento local.

---

# Capa Domain

Responsabilidades:

* Entidades de negocio.
* Contratos de repositorios.

Las entidades representan el modelo de negocio independiente de Flutter, APIs o bases de datos.

Ejemplos:

* WeatherEntity
* EventEntity
* LocationEntity

---

# Capa Data

Responsabilidades:

* Consumo de APIs.
* Persistencia local.
* Conversión de datos externos.
* Implementación de repositorios.

Incluye:

* DataSources remotos.
* DataSources locales.
* DTOs.
* Implementaciones de repositorios.

---

# Gestión de Estado

Se utiliza Riverpod 2.x con generación de código.

Razones:

* Inyección de dependencias sencilla.
* Gestión reactiva del estado.
* Integración con AsyncValue.
* Reducción de boilerplate.
* Fácil testing.

Cada módulo posee sus propios providers especializados.

---

# Patrón Repository

Se implementa Repository Pattern para desacoplar la lógica de negocio de las fuentes de datos.

Beneficios:

* Facilita pruebas unitarias.
* Permite cambiar implementaciones sin afectar la capa superior.
* Facilita soporte offline.

Ejemplo:

WeatherRepository

puede obtener datos desde:

* API remota.
* Caché local.

sin que la UI conozca el origen.

---

# Persistencia Local

La aplicación utilizará almacenamiento local para:

* Caché de clima.
* Caché de eventos.
* Eventos favoritos.

Objetivos:

* Soporte offline.
* Persistencia entre sesiones.
* Mejor experiencia de usuario.

---

# Estrategia Offline First

Cuando exista conectividad:

1. Se consulta la API.
2. Se actualiza la caché local.
3. Se muestran datos actualizados.

Cuando no exista conectividad:

1. Se detecta la ausencia de red.
2. Se informa al usuario.
3. Se muestran los últimos datos almacenados localmente.

---

# Manejo de Errores

Se implementará una estrategia centralizada para:

* Errores de red.
* Errores de ubicación.
* Errores de almacenamiento local.
* Errores inesperados.

Esto evita lógica repetida y mejora la experiencia de usuario.

---

# Flavors

La aplicación contará con dos ambientes:

## Dev

* Nombre diferenciado.
* Icono diferenciado.
* Recursos independientes.

## Prod

* Configuración final de producción.

Esto permite demostrar manejo de múltiples ambientes y configuración profesional de proyectos Flutter.

---

# Principios Aplicados

* Separation of Concerns.
* Single Responsibility Principle.
* Dependency Inversion Principle.
* Repository Pattern.
* Feature-First Architecture.
* Clean Architecture Simplificada.
* State Management con Riverpod.
* Offline First.
* Código orientado a mantenibilidad y escalabilidad.
