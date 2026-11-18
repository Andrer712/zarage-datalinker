# ZARAGE DATALINKER

**Gestor moderno de enlaces de directorios para Windows.**

Desarrollado por **WHITEWAY** bajo la marca **ZARAGE**.

[Español](#español) | [English](#english)

---

# Español

## ¿Qué es ZARAGE DATALINKER?

ZARAGE DATALINKER es una herramienta desarrollada en PowerShell que permite mover carpetas pesadas a otro disco y crear automáticamente enlaces de directorio mediante `mklink /J`.

Su objetivo es liberar espacio en el disco principal sin perder el acceso a las carpetas desde su ubicación original.

## Características

- **Interfaz moderna:** diseño oscuro con detalles dorados.
- **Explorador moderno:** selector nativo de carpetas de Windows.
- **Mover carpetas:** permite trasladar carpetas a otro disco o ubicación.
- **Enlaces automáticos:** crea enlaces de directorio mediante `mklink /J`.
- **Fácil de utilizar:** selecciona el origen, el destino y ejecuta la operación.
- **Recuperación ante errores:** intenta devolver la carpeta a su ubicación original si falla la creación del enlace.

## Requisitos

- Windows 10 o Windows 11.
- Windows PowerShell 5.1.
- .NET Framework con soporte para WPF.
- Permisos suficientes para mover las carpetas seleccionadas.

## Instalación

1. Descarga este repositorio desde GitHub.
2. Extrae los archivos si descargaste el proyecto en ZIP.
3. Abre Windows PowerShell.
4. Accede a la carpeta del proyecto.
5. Ejecuta el siguiente comando:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\ZarageDatalinker.ps1"
```

## Cómo utilizarlo

1. Abre ZARAGE DATALINKER.
2. Selecciona la carpeta original que deseas mover.
3. Selecciona el disco o directorio de destino.
4. Pulsa **MOVER CARPETA Y CREAR ENLACE**.
5. Confirma la operación.
6. El programa moverá la carpeta y creará un enlace en su ubicación original.

## Recomendaciones importantes

- Comprueba que el disco de destino tenga espacio suficiente.
- Cierra los programas que estén utilizando la carpeta antes de moverla.
- Realiza una copia de seguridad de los archivos importantes.
- No elimines la carpeta de destino mientras utilices el enlace.
- Los enlaces `/J` están destinados a directorios y sistemas de archivos locales compatibles.

## Tecnologías utilizadas

- PowerShell 5.1.
- WPF (Windows Presentation Foundation).
- C#.
- Windows Shell API.
- CMD (`mklink /J`).

## Licencia

Este proyecto está publicado bajo la licencia [MIT](LICENSE).

## Autor

**WHITEWAY**

Publicado bajo la marca **ZARAGE**.

---

# English

## What is ZARAGE DATALINKER?

ZARAGE DATALINKER is a PowerShell application that allows users to move large folders to another drive and automatically create directory junctions using `mklink /J`.

Its purpose is to free up space on the primary drive while maintaining access to folders from their original locations.

## Features

- **Modern Interface:** Dark theme with elegant gold accents.
- **Modern Folder Picker:** Native Windows folder selection dialog.
- **Move Folders:** Relocate folders to another drive or directory.
- **Automatic Junctions:** Creates directory junctions using `mklink /J`.
- **Easy to Use:** Select the source, choose the destination, and execute.
- **Error Recovery:** Attempts to restore the original folder if junction creation fails.

## Requirements

- Windows 10 or Windows 11.
- Windows PowerShell 5.1.
- .NET Framework with WPF support.
- Appropriate permissions to move the selected folders.

## Installation

1. Download this repository from GitHub.
2. Extract the files if you downloaded the ZIP archive.
3. Open Windows PowerShell.
4. Navigate to the project directory.
5. Run the following command:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\ZarageDatalinker.ps1"
```

## How to Use

1. Open ZARAGE DATALINKER.
2. Select the original folder you want to move.
3. Select the destination drive or directory.
4. Click **MOVE FOLDER AND CREATE JUNCTION**.
5. Confirm the operation.
6. The application moves the folder and creates a directory junction at its original location.

## Important Notes

- Make sure the destination drive has enough free space.
- Close applications that are using the folder before moving it.
- Back up important files before performing the operation.
- Do not delete the destination folder while the junction is in use.
- Directory junctions are intended for compatible local Windows file systems.

## Technologies

- PowerShell 5.1.
- WPF (Windows Presentation Foundation).
- C#.
- Windows Shell API.
- Windows Command Prompt (`mklink /J`).

## License

This project is licensed under the [MIT License](LICENSE).

## Author

**WHITEWAY**

Published under the **ZARAGE** brand.

---

**ZARAGE DATALINKER — Gestiona tus directorios. Optimiza tu almacenamiento.**

**ZARAGE DATALINKER — Manage your directories. Optimize your storage.**