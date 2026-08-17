# Carpeta de Documentacion Tecnica (docs/)

Este directorio contiene las bitacoras de pruebas de sistemas operativos, guias tecnicas de migracion, notas de diseno y listas de juegos pendientes para la consola portatil R35 Ultra (Rockchip RK3326).

---

## Indice de Documentos

| Documento | Descripcion y Contexto |
| :--- | :--- |
| **`BITACORA_PRUEBAS_SISTEMAS.md`** | Registro cronologico exhaustivo de todas las imagenes de firmware probadas (ArkOS, AmberELEC, ROCKNIX, EmuELEC), detallando voltajes del PMIC, comportamiento de LEDs y diagnostico de hardware. |
| **`INVESTIGACION_KERNEL_Y_OPTIMIZACION_PPSSPP_R35_ULTRA.md`** | Investigacion tecnica de bajo nivel sobre cuellos de botella (CPU In-Order, Mali TBDR, LPDDR3), optimizaciones de Kernel (ZRAM, SCHED_FIFO) y calibracion extrema de PPSSPP con referencias bibliograficas. |
| **`AUDITORIA_PROCESOS_Y_SERVICIOS_SEGUNDO_PLANO.md`** | Auditoria integral de demonios Systemd, sockets de red y procesos de fondo con evaluacion de consumo de recursos y modo ultra-ahorro. |
| **`GUIA_MIGRACION_Y_SISTEMAS_R35_ULTRA.md`** | Guia tecnica detallada sobre la estructura de particiones, compatibilidad del kernel Linux 6.x vs 4.4 y metodos de instalacion. |
| **`DIAGNOSTICO_Y_PLAN_LIMPIEZA.md`** | Plan de auditoria y curacion del almacenamiento, eliminacion de ROMs corruptas y diseno de la coleccion esencial. |
| **`JUEGOS_PENDIENTES.md`** | Lista de candidatos y juegos deseados para futuras ampliaciones en PlayStation 1 y otras plataformas aprovechando el espacio libre de la MicroSD. |
| **`logs/`** | Directorio de evidencias en crudo con volcados de diagnostico en vivo capturados por SSH. |

---

*Para la memoria tecnica global del proyecto, consultar el archivo principal `MEMORIA_TECNICA_PROYECTO_R35_ULTRA.md` en la raiz del repositorio.*
