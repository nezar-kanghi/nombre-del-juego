# Pruebas de build

## Prueba 1 - Build de escritorio (Windows)
- **Fecha:** 30/09/2026
- **Versión de Godot:** 4.7.2 stable
- **Preset:** Windows Desktop (x86_64)
- **Ruta de la build:** ../build/juego_de_nezar.exe
- **Qué se probó:** arranque del ejecutable, carga de la escena principal, fondo parallax.
- **Resultado:** OK

## Cómo reproducir la build
1. Abrir el proyecto con Godot 4.7.2.
2. Instalar las plantillas de exportación (Proyecto → Exportar → Administrar plantillas).
3. Proyecto → Exportar → preset "Windows Desktop" → Exportar proyecto.
4. La build se genera en `../build/` (carpeta junto al proyecto).
