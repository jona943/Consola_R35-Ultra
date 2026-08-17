import os, sys, shutil

src_base = '/home/dev-jonathan/Escritorio/R35_Ultra/Consola_R35-Ultra/copia_r35Ultra'
dst_base = '/media/dev-jonathan/16GB'

catalog = {
    'nes': [
        'Super Mario Bros. (World).zip',
        'Super Mario Bros. 2 (USA).nes',
        'Super Mario Bros. 3 (USA).zip',
        'Dr. Mario (USA) (Beta) (1990-04-27).zip',
        'Contra (USA).zip',
        'Zelda II - The Adventure of Link (Europe).nes',
        'Adventure Island II (USA).nes'
    ]
}

# Limpiar carpetas no deseadas
unused = ['gamegear', 'gb', 'gbc', 'megadrive', 'mame', 'dreamcast', 'pcengine', 'r36-ultra']
for u in unused:
    p = os.path.join(dst_base, u)
    if os.path.exists(p):
        shutil.rmtree(p, ignore_errors=True)

# Procesar NES
for sys_name, file_list in catalog.items():
    s_dir = os.path.join(src_base, sys_name)
    d_dir = os.path.join(dst_base, sys_name)
    
    if os.path.exists(d_dir):
        shutil.rmtree(d_dir, ignore_errors=True)
    os.makedirs(d_dir, exist_ok=True)
    
    d_img = os.path.join(d_dir, 'images')
    s_img = os.path.join(s_dir, 'images')
    if os.path.exists(s_img):
        os.makedirs(d_img, exist_ok=True)
        
    print(f'Procesando {sys_name.upper()}...')
    for f in file_list:
        src_f = os.path.join(s_dir, f)
        dst_f = os.path.join(d_dir, f)
        if os.path.exists(src_f):
            if os.path.isfile(src_f):
                shutil.copy2(src_f, dst_f)
            elif os.path.isdir(src_f):
                shutil.copytree(src_f, dst_f)
            print(f'  [OK] {f}')
            
            base_name = os.path.splitext(f)[0]
            if os.path.exists(s_img):
                for ext in ['.png', '.jpg', '-image.png', '-image.jpg', '-thumb.png']:
                    c_src = os.path.join(s_img, base_name + ext)
                    if os.path.exists(c_src):
                        shutil.copy2(c_src, os.path.join(d_img, base_name + ext))
                        break
        else:
            print(f'  [NO ENCONTRADO] {f}')
            
    s_xml = os.path.join(s_dir, 'gamelist.xml')
    if os.path.exists(s_xml):
        shutil.copy2(s_xml, os.path.join(d_dir, 'gamelist.xml'))

# Asegurar BIOS
s_bios = os.path.join(src_base, 'bios')
d_bios = os.path.join(dst_base, 'bios')
if os.path.exists(s_bios):
    os.makedirs(d_bios, exist_ok=True)
    for bf in os.listdir(s_bios):
        s_bf = os.path.join(s_bios, bf)
        d_bf = os.path.join(d_bios, bf)
        if os.path.isfile(s_bf):
            shutil.copy2(s_bf, d_bf)
        elif os.path.isdir(s_bf) and not os.path.exists(d_bf):
            shutil.copytree(s_bf, d_bf)

print('Sincronizando...')
os.system('sync')
print('COMPLETADO AL 100%')
