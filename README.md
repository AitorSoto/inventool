# Inventool

Inventool es una aplicación de gestión de herramientas que permite a los usuarios agregar, editar, eliminar y escanear herramientas utilizando códigos QR. La aplicación también permite asignar herramientas a personas y cambiar entre modos claro y oscuro.

## Características

- Agregar nuevas herramientas con ID, nombre y asignación opcional a una persona.
- Editar y eliminar herramientas existentes.
- Escanear códigos QR para buscar herramientas en la base de datos.
- Asignar herramientas a personas.
- Cambiar entre modos claro y oscuro.

## Instalación

1. Clona el repositorio:

   ```bash
   git clone https://github.com/AitorSoto/inventool.git
   cd inventool
   ```

2. Instala las dependencias:

   ```dart
   flutter pub get
   ```

3. Ejecuta la aplicación:
   ```dart
   flutter run
   ```

## Estructura del proyecto

- `main.dart`: Archivo principal de la aplicación que configura el RouteObserver y define la estructura básica de la aplicación.
- `screens/`: Contiene las pantallas principales de la aplicación.
  - `list_screen.dart`: Pantalla que muestra la lista de herramientas.
  - `add_tool_screen.dart`: Pantalla para agregar nuevas herramientas.
  - `edit_tool_screen.dart`: Pantalla para editar y eliminar herramientas.
  - `scan_screen.dart`: Pantalla para escanear códigos QR.
  - `add_volunteer_screen.dart`: Pantalla para agregar voluntarios.
- `utils/`: Contiene utilidades y helpers.
  - `database_helper.dart`: Helper para interactuar con la base de datos SQLite.
- `models/`: Contiene las clases de modelo.
  - `tool.dart`: Modelo de datos para las herramientas.
  - `volunteer.dart`: Modelo de datos para los voluntarios

## Uso

### Agregar una Herramienta

1. Abre el menú lateral y selecciona "Añadir herramientas".
2. Completa los campos de ID, nombre y ID de persona (opcional).
3. Presiona "Agregar Herramienta".

### Editar o eliminar una herramienta

1. En la pantalla de lista de herramientas, selecciona la herramienta que deseas editar o eliminar.
2. Realiza los cambios necesarios y presiona "Actualizar Herramienta" o presiona el ícono de eliminar para eliminar la herramienta.

### Escanear una herramienta

1. Selecciona la opción "Escanear QR" en la barra de navegación inferior.
2. Escanea el código QR de la herramienta.
3. Si la herramienta existe en la base de datos, se mostrará la información de la herramienta. Si no, se mostrará un mensaje de error.

### Cambiar entre Modo Claro y Oscuro

1. Abre el menú lateral y selecciona "Modo Claro/Oscuro".

### Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o envía un pull request.

# Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
