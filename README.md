
# Pokémon App

Esta es una aplicación móvil de Pokémon que permite a los usuarios capturar, liberar y gestionar Pokémon. La app está desarrollada con Flutter y utiliza la arquitectura basada en `Cubit` para el manejo de estados. A continuación, se describen las principales pantallas de la aplicación y sus características.

## Funcionalidades principales

- Captura y liberación de Pokémon.
- Listado de Pokémon capturados.
- Filtrado y búsqueda de Pokémon por nombre y tipo.
- Login básico con autenticación.

## Tecnologías utilizadas

- **Flutter**: Framework de desarrollo multiplataforma.
- **Dio**: Cliente HTTP para la comunicación con la API.
- **Bloc/Cubit**: Manejo de estado reactivo.
- **GoRouter**: Navegación en la aplicación.
- **PokéAPI**: API externa utilizada para obtener los datos de los Pokémon.

## Pantallas

### 1. Pantalla de listado de Pokémon

La pantalla principal muestra una lista de Pokémon con la opción de buscar y filtrar por nombre y tipo. Los usuarios pueden capturar Pokémon tocando sobre el icono correspondiente, y el estado de captura se reflejará visualmente en la lista. Se incluye:

- **Barra de búsqueda**: Permite buscar por nombre de Pokémon.
- **Filtro por tipo**: Un `DropdownButton` que permite filtrar los Pokémon por tipo.
- **Paginador**: Control de paginación flotante para navegar entre las diferentes páginas de resultados.
- **Acciones**:
  - **Botón de Captura**: Permite capturar un Pokémon.
  - **Botón de lista de capturados**: Un botón flotante que navega hacia la pantalla de Pokémon capturados.

### 2. Pantalla de Pokémon capturados

Esta pantalla muestra los Pokémon que han sido capturados por el usuario. Cada Pokémon tiene un botón de eliminación para liberarlo. Si no hay Pokémon capturados, se muestra un mensaje de estado vacío.

- **Lista de Pokémon capturados**: Muestra el nombre, imagen, número y tipo de los Pokémon capturados.
- **Acciones**:
  - **Botón de eliminar**: Permite liberar un Pokémon individualmente.
  - **Liberar todos los Pokémon**: Permite liberar todos los Pokémon capturados a través de un diálogo de confirmación.

### 3. Pantalla de Login

Pantalla de autenticación básica con un formulario de inicio de sesión que incluye un campo de usuario y contraseña con funcionalidad para mostrar u ocultar la contraseña. Por defecto, ambos campos están prellenados con el valor `admin`.

- **Formulario de login**: Valida que los campos no estén vacíos antes de proceder.
- **Campos**:
  - **Usuario**: Prellenado con el valor `admin`.
  - **Contraseña**: Prellenado con el valor `admin` y opción de mostrar/ocultar la contraseña.
- **Acciones**:
  - **Botón de login**: Valida las credenciales y navega a la pantalla principal si son correctas.

## Instalación y configuración

1. Clona el repositorio:
   ```bash
   git clone git@github.com:nicoGG/pokemon-app.git
   ```
2. Navega al directorio del proyecto:
   ```bash
   cd pokemon-app
   ```
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Estructura del proyecto

```bash
lib/
├── cubits/
│   ├── login/
│   ├── pokemon/
├── models/
├── pages/
│   ├── captured_pokemons_page.dart
│   ├── login_page.dart
│   ├── pokemon_list_page.dart
└── app/
    └── utils/
```

## Uso

1. Al iniciar la aplicación, verás la lista de Pokémon desde la **Pantalla de listado de Pokémon**. 
   - Puedes buscar Pokémon por nombre o filtrar por tipo utilizando los controles en la parte superior de la pantalla.
   - Toca un Pokémon para capturarlo o liberarlo.
2. Accede a la lista de Pokémon capturados tocando el botón flotante con el icono de lista.
3. Puedes liberar todos los Pokémon desde la pantalla de capturados utilizando el botón de eliminar en la barra superior.
4. Navega al **Login** desde la pantalla de Pokémon utilizando el icono de usuario en la barra de navegación.

## Contribuciones

¡Contribuciones son bienvenidas! Si encuentras algún error o quieres mejorar la funcionalidad, no dudes en abrir un *issue* o enviar un *pull request*.

---

## Licencia

Este proyecto está bajo la licencia [MIT](LICENSE).
