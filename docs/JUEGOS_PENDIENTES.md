# Nota de Juegos Pendientes y Catalogo Futuro (PS1 / Retro)

Este documento registra los juegos pendientes y títulos candidatos para futuras expansiones en la tarjeta MicroSD de la consola R35 Ultra.

---

## 1. Estado Actual de PlayStation 1 en la Consola

Actualmente se encuentran instalados y verificados al 100% (60 FPS con caratulas oficiales en HD) los siguientes 3 titulos clasicos:

1. **Crash Bandicoot (USA)** (602.8 MB)
2. **Doom (USA) (Rev 1)** (277.3 MB)
3. **Yu-Gi-Oh! Forbidden Memories (USA)** (493.9 MB)

* Espacio total ocupado por PS1: **1.37 GB**
* Espacio libre restante en MicroSD: **3.8 GB disponibles**

---

## 2. Lista de Juegos Pendientes Candidatos (Wishlist PS1)

Los siguientes titulos han sido seleccionados como candidatos prioritarios para agregar en futuras sesiones aprovechando los 3.8 GB disponibles:

* **Castlevania: Symphony of the Night** (~350 MB en CHD/PBP o ~500 MB en BIN/CUE) - Obra maestra de accion y exploracion 2D.
* **Crash Team Racing (CTR)** (~300 MB) - El juego de carreras de karts por excelencia de PS1.
* **Silent Hill** (~300 MB) - Clasico fundamental de terror psicologico en 3D.
* **Resident Evil 2 (DualShock Edition)** (~700 MB en 2 discos) - Survival horror clasico.
* **Tekken 3** (~450 MB) - El mejor juego de pelea 3D de la generacion de 32 bits.
* **Metal Gear Solid** (~750 MB en 2 discos) - Aventura de accion y sigilo tactico.
* **Spyro the Dragon** (~350 MB) - Plataformas 3D clasico.
* **Tony Hawk's Pro Skater 2** (~400 MB) - Skateboarding y banda sonora iconica.
* **Pepsiman** (~150 MB) - Clasico arcade de reflejos y comedia.

---

## 3. Procedimiento para Agregar Juegos Pendientes en el Futuro

1. Conectar la consola a la misma red Wi-Fi y verificar direccion IP (`ssh root@emuelec.local`).
2. Transferir la carpeta o archivo `.cue/.bin` o `.chd` a `/storage/roms/psx/`.
3. Guardar la caratula en `/storage/roms/psx/images/NombreDelJuego.png`.
4. Registrar los metadatos en `/storage/roms/psx/gamelist.xml`.
5. Ejecutar `chmod -R 777 /storage/roms/psx && sync`.
6. En la consola presionar `Start` -> `Ajustes de Juegos` -> `Actualizar lista de juegos`.
