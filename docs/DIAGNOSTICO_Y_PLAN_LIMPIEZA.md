# Diagnóstico y Plan de Optimización - MicroSD R35 Ultra

## 1. Estado del Almacenamiento
* **Dispositivo:** `/dev/sdb1` (Montado en `/media/dev-jonathan/_¼Ӿ_`)
* **Sistema de archivos:** `FAT32 (vfat)`
* **Capacidad:** ~50 GB Total | ~43 GB Usados (85%) | ~7.9 GB Libres
* **Estado actual de montaje:** `ro` (Solo Lectura automático activado por protección del kernel tras detectar sectores con errores de E/S en los archivos `gamelist.xml` originales de fábrica).

---

## 2. Análisis del Contenido Actual (+30,000 archivos de "ruido")
La tarjeta contiene miles de clones, ROMs en chino/japonés duplicadas, hacks y archivos de metadatos dañados:
* **NES / Famicom:** ~12,400 archivos (la gran mayoría repetidos o hacks).
* **MAME / Arcade:** ~11,000 archivos (muchos clones o incompatibles).
* **SNES / SFC:** ~4,100 archivos.
* **GB / GBC / GBA:** ~9,600 archivos.
* **Mega Drive / Genesis:** ~2,100 archivos.
* **Neo-Geo / CPS1, CPS2, CPS3:** Cientos de ROMs repetidas o sin depurar.
* **PSP / Dreamcast:** Múltiples juegos pesados o demos.
* **PSX:** Solo contiene imágenes de carátulas (`.png`), sin imágenes ejecutables de juegos.

---

## 3. Procedimiento para Reparar y Desbloquear Escritura

Para poder escribir en la tarjeta, borrar los juegos sobrantes y regenerar los `gamelist.xml`, ejecuta en tu terminal con `sudo`:

```bash
# 1. Desmontar la tarjeta
sudo umount /dev/sdb1

# 2. Reparar el sistema de archivos FAT32 automáticamente
sudo fsck.vfat -a -v /dev/sdb1

# 3. Volver a montar la tarjeta en modo lectura/escritura
udisksctl mount -b /dev/sdb1
```

*(O en Windows: clic derecho en la unidad USB > Propiedades > Herramientas > Comprobar ahora / Reparar unidad).*

---

## 4. Plan de Curaduría (Juegos Clásicos y Esenciales)

Una vez habilitada la escritura, se conservarán únicamente los títulos principales y de mejor rendimiento para el chip RK3326:

### Nintendo
* **NES:** Super Mario Bros 1, 2, 3, The Legend of Zelda 1 & 2, Metroid, Castlevania 1, 2, 3, Mega Man 1 al 6, Contra, Super C, DuckTales, Kirby's Adventure, Ninja Gaiden 1, 2, 3, Punch-Out!!, Tetris, Double Dragon 1 & 2, etc.
* **SNES:** Super Mario World 1 & 2 (Yoshi's Island), Super Mario Kart, Chrono Trigger, Super Metroid, The Legend of Zelda: A Link to the Past, Donkey Kong Country 1, 2, 3, Mega Man X, X2, X3, Street Fighter II Turbo, Final Fantasy IV & VI, Secret of Mana, EarthBound, Super Castlevania IV, TMNT: Turtles in Time, Killer Instinct, etc.
* **Game Boy / GBC:** Pokémon Rojo/Azul/Amarillo/Oro/Plata/Cristal, Zelda Link's Awakening DX, Zelda Oracle of Ages/Seasons, Super Mario Land 1 & 2, Wario Land 1, 2, 3, Tetris, etc.
* **Game Boy Advance (GBA):** Pokémon Rojo Fuego/Verde Hoja/Esmeralda, Zelda: The Minish Cap, Zelda: A Link to the Past, Metroid Fusion, Metroid Zero Mission, Golden Sun 1 & 2, Mario & Luigi Superstar Saga, Advance Wars 1 & 2, Castlevania: Aria of Sorrow, etc.
* **Nintendo 64:** Super Mario 64, Mario Kart 64, Zelda Ocarina of Time, Zelda Majora's Mask, Super Smash Bros, Star Fox 64, Banjo-Kazooie, Diddy Kong Racing, F-Zero X, etc.

### Sega
* **Mega Drive / Genesis:** Sonic the Hedgehog 1, 2, 3 & Knuckles, Streets of Rage 1, 2, 3, Golden Axe 1 & 2, Shinobi III, Gunstar Heroes, Castlevania Bloodlines, Contra Hard Corps, Aladdin, etc.

### Arcade & Neo-Geo
* **CPS1, CPS2, CPS3, Neo-Geo, MAME:** Metal Slug 1 al 5/X, The King of Fighters 97/98/2002, Street Fighter II / Alpha 3 / III 3rd Strike, Marvel vs Capcom, Cadillacs and Dinosaurs, Captain Commando, Sunset Riders, TMNT, The Simpsons, Windjammers, Garou: Mark of the Wolves, etc.

### Sony & Dreamcast
* Títulos emblemáticos seleccionados y optimizados para la consola.

---

## 5. Actualización de Metadatos (`gamelist.xml`)
* Eliminación de archivos `gamelist.xml` corruptos.
* Creación de nuevos archivos XML válidos, limpios y compatibles con EmulationStation para inicio rápido y sin bloqueos.
