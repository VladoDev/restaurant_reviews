# Restaurant Reviews App 🍽️

Una aplicación móvil desarrollada en **Flutter** para la gestión y visualización de reseñas de restaurantes, enfocada en la eficiencia técnica y una experiencia de usuario fluida.

## 🚀 Arquitectura y Diseño
El proyecto sigue el patrón de diseño **MVVM (Model-View-ViewModel)**, garantizando una separación clara de responsabilidades:

* **Base API Client:** Configuración centralizada para llamadas de red utilizando un cliente base para estandarizar las peticiones.
* **Providers:** Encargados de la comunicación directa con los endpoints de la API haciendo uso de la clase base.
* **Repositories:** Capa intermedia que procesa y transforma los datos crudos de la API en objetos de modelo listos para el consumo.
* **ViewModels:** Manejan el estado de la aplicación y notifican a la vista mediante **GetX** cuando la información está lista para mostrarse.
* **Bindings:** Se utilizan para la inyección de dependencias, conectando controladores y repositorios con sus respectivas vistas desde el inicio de la navegación.



## 🛠️ Librerías Principales
* **GetX:** Utilizado para la gestión de estado, navegación por rutas nombradas e inyección de dependencias.
* **Dio:** Cliente HTTP robusto para la gestión de peticiones de red.
* **Image Picker:** Permite a los usuarios seleccionar imágenes directamente desde la galería o cámara del dispositivo.
* **Cached Network Image:** Implementado para almacenar imágenes en caché, optimizando el consumo de datos y disminuyendo drásticamente los tiempos de carga.
* **Flutter Rating Bar:** Utilizada para una visualización intuitiva y funcional de las calificaciones mediante estrellas.

## ✨ Características Destacadas
* **Hero Animations:** Implementación de transiciones fluidas entre la lista de restaurantes y la vista de detalle, mejorando la continuidad visual de la interfaz.
* **Validación de Reseñas:** El sistema impide que un mismo usuario publique más de una reseña en un mismo restaurante mediante una validación de nombre en tiempo real.
* **Gestión de Datos:** Soporte completo para crear y eliminar tanto restaurantes como reseñas.
---

### Instalación
1. Clona el repositorio.
2. Ejecuta `flutter pub get` para instalar las dependencias.
3. Asegúrate de configurar las constantes de la API en `lib/helpers/api_constants.dart`.
4. Ejecuta el proyecto con `flutter run`.

![Simulator Screen Recording - iPhone 17 Pro Max - 2026-01-31 at 00 02 42](https://github.com/user-attachments/assets/1c28e3bb-e45a-4537-a111-9864f38e0642)

