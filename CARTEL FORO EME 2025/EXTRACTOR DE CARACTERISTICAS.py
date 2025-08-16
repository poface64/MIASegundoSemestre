### Cargar librerias ###
import cv2
import numpy as np
from tensorflow.keras.applications import VGG16
from tensorflow.keras.applications.vgg16 import preprocess_input
from tensorflow.keras.models import Model
from tensorflow.keras.layers import GlobalAveragePooling2D
import numpy as np

### Cargar función para la lista de elementos ###
### Función que selecciona rutas ##
def selector(ruta_carpeta: str, cantidad_rutas_a_seleccionar: int, semilla_fija: int = 42) -> list:
    """
    Selecciona una muestra aleatoria de imágenes JPEG de una carpeta dada.

    Args:
        ruta_carpeta (str): La ruta de la carpeta que contiene las imágenes.
        cantidad_rutas_a_seleccionar (int): El número de rutas de imágenes a seleccionar aleatoriamente.
        semilla_fija (int, optional): Una semilla para el generador de números aleatorios.
                                      Usar una semilla fija asegura que la selección sea reproducible.
                                      Por defecto es 42.

    Returns:
        list: Una lista de las rutas completas de las imágenes seleccionadas aleatoriamente.
              Retorna una lista vacía si no se encuentran imágenes JPEG,
              la carpeta no existe, o la cantidad solicitada es inválida.
    """
    # Verify if the folder exists
    if not os.path.exists(ruta_carpeta):
        print(f"Error: La carpeta '{ruta_carpeta}' no existe.")
        return []

    imagenes_jpeg = []
    # Iterate through files in the directory to find JPEG images
    for nombre_archivo in os.listdir(ruta_carpeta):
        # Check if the file is a JPEG (case-insensitive)
        if nombre_archivo.lower().endswith(".jpeg") or nombre_archivo.lower().endswith(".jpg"):
            imagenes_jpeg.append(os.path.join(ruta_carpeta, nombre_archivo))

    # If no JPEG images are found
    if not imagenes_jpeg:
        print(f"No se encontraron imágenes JPEG en la carpeta '{ruta_carpeta}'.")
        return []

    print(f"Se encontraron {len(imagenes_jpeg)} imágenes JPEG en la carpeta.")

    # Validate the requested number of samples
    if not (1 <= cantidad_rutas_a_seleccionar <= len(imagenes_jpeg)):
        print(f"Error: La cantidad de rutas a seleccionar ({cantidad_rutas_a_seleccionar}) "
              f"debe estar entre 1 y {len(imagenes_jpeg)} (el número total de imágenes JPEG).")
        return []

    # Set the random seed for reproducibility
    random.seed(semilla_fija)

    # Select random samples
    muestras_seleccionadas = random.sample(imagenes_jpeg, cantidad_rutas_a_seleccionar)
    return muestras_seleccionadas

### Cargar función para preprocesar las imagenes ###
def procesar_imagenes(lista_rutas, tamaño=(224, 224)):
    imagenes = []
    for ruta in lista_rutas:
        try:
            img_bgr = cv2.imread(ruta)
            if img_bgr is None:
                print(f"Advertencia: No se pudo cargar la imagen en la ruta: {ruta}. Saltando.")
                continue

            img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
            img_resized = cv2.resize(img_rgb, tamaño)
            img_preprocessed = preprocess_input(img_resized)
            imagenes.append(img_preprocessed)

        except Exception as e:
            print(f"Error procesando {ruta}: {e}")

    X = np.array(imagenes)
    return X

### Función para extraer GlobalAveragePolling2D
def extraer_caracteristicas_GAP(lista_rutas, tamaño=(224, 224)):
    """
    Extrae vectores de características de imágenes usando VGG16 + GlobalAveragePooling2D.

    Args:
        lista_rutas (list): Lista de rutas a las imágenes.
        tamaño (tuple): Tamaño al que se redimensionan las imágenes.

    Returns:
        numpy.ndarray: Matriz N x P con vectores de características compactos.
    """
    # 1. Preprocesar imágenes
    X = procesar_imagenes(lista_rutas, tamaño=tamaño)
    
    if X.size == 0:
        print("No se pudo procesar ninguna imagen.")
        return np.array([])

    # 2. Cargar el modelo base VGG16 sin la parte densa
    base_model = VGG16(weights='imagenet', include_top=False, input_shape=(tamaño[1], tamaño[0], 3))

    # 3. Añadir GlobalAveragePooling2D para vector compacto
    x = base_model.output
    x = GlobalAveragePooling2D()(x)
    model = Model(inputs=base_model.input, outputs=x)

    # 4. Extraer características
    características = model.predict(X, verbose=1)

    return características

###########################################################################
# Seleccionar las imagenes #
ruta = "C:\\Users\\Angel\\Desktop\\Cartel FORO 2025\\CARAS 1\\Humans"
muestras = selector(ruta,7069,62)
#muestras

# Extraer las caracteristicas #
X_feat = extraer_caracteristicas_GAP(muestras)
X_feat.ndim

# Crear un dataframe de los vectores #
df = pd.DataFrame(X_feat)
#df
# Insertar el nombre de la imagen:
nombres = [os.path.basename(ruta) for ruta in muestras]
nombres1 = [int(n[n.find('(')+1:n.find(')')]) for n in nombres if '(' in n and ')' in n and n.find('(') < n.find(')') and n.find('(')+1 < n.find(')')]
df.insert(0, 'imagen', nombres1)


# Exportar a CSV
df.to_csv("Caracteristicas2.csv", index=False)

