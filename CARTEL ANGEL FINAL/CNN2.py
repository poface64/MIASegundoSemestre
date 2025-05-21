
# Cargar las librerias necesarias #


### Función para seleccionar imagenes ###
def selector(ruta_carpeta):
    """
    Selecciona una muestra aleatoria de imágenes JPEG de una carpeta dada.
    Args:
        ruta_carpeta (str): La ruta de la carpeta que contiene las imágenes.
    Returns:
        list: Una lista de las rutas completas de las imágenes seleccionadas aleatoriamente,
              o None si no se encuentran imágenes JPEG o la carpeta no existe.
    """
    if not os.path.exists(ruta_carpeta):
        print(f"Error: La carpeta '{ruta_carpeta}' no existe.")
        return None

    imagenes_jpeg = []
    for nombre_archivo in os.listdir(ruta_carpeta):
        if nombre_archivo.lower().endswith(".jpeg") or nombre_archivo.lower().endswith(".jpg"):
            imagenes_jpeg.append(os.path.join(ruta_carpeta, nombre_archivo))

    if not imagenes_jpeg:
        print(f"No se encontraron imágenes JPEG en la carpeta '{ruta_carpeta}'.")
        return None

    print(f"Se encontraron {len(imagenes_jpeg)} imágenes JPEG en la carpeta.")

    while True:
        try:
            num_muestras = int(input(f"¿Cuántas imágenes aleatorias quieres seleccionar (1 - {len(imagenes_jpeg)})? "))
            if 1 <= num_muestras <= len(imagenes_jpeg):
                break
            else:
                print(f"Por favor, ingresa un número entre 1 y {len(imagenes_jpeg)}.")
        except ValueError:
            print("Entrada inválida. Por favor, ingresa un número entero.")

    muestras_seleccionadas = random.sample(imagenes_jpeg, num_muestras)
    return muestras_seleccionadas

####        

### Seleccionar N posibles caras ###
ruta = "C:\\Users\\Angel\\Desktop\\Cartel FORO 2025\\CARAS 1\\Humans"
muestras = selector(ruta)

# Revisar las muestras
muestras

