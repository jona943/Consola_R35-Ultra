# Carpeta de Imagenes de Sistemas Operativos (images/)

Este directorio contiene las imagenes de firmware evaluadas durante el proceso de diagnostico y compatibilidad de hardware para la consola R35 Ultra (placa v12 / RK3326).

---

## Estructura de Subcarpetas

| Carpeta | Sistema Operativo | Kernel | Diagnostico y Estado |
| :--- | :--- | :---: | :--- |
| **`ROCKNIX/`** | ROCKNIX (Imagen B para Clones) | Linux 6.x | Sistema alternativo 100% funcional en pantalla y energia. Utilizado con exito para el desbloqueo eMMC por arranque cruzado. |
| **`ArkOS/`** | ArkOS 2.0 MultiPanel | Linux 4.4 | No compatible: El Kernel 4.4 legacy no soporta el mapa de voltajes del PMIC moderno 2025/2026 (activa corte por sobrevoltaje / LED Rojo). |
| **`AmberELEC/`** | AmberELEC-RG351MP | Linux 4.4 | No compatible: Mismo fallo de inicializacion del controlador de energia en Kernel 4.4. |

---

*Nota: Los archivos pesados `.img` / `.tar.gz` estan excluidos en `.gitignore` para mantener el repositorio ligero.*
