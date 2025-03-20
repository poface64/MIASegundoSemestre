#### Paquetes necesarios ####
using Plots
using Images
using StatsBase

# Función del gradiente de SOBEL #
function imsobel(img_ruta::String)
    # Cargar la imagen
    img = load(img_ruta)
    # Convertir la imagen a escala de grises y multiplicar por 255
    img1 = Gray.(img) .* 255
   # Generar la matriz que detecta en Gx
    gxk = [-1 0 1; -2 0 2; -1 0 1]
    # Generar la matriz que detecta en Gy
    gyk = gxk' # Usamos la transpuesta de gxk
    # Obtener las dimensiones de la imagen y el kernel
    imdim = size(img1)
    kerdim = size(gxk)
    # Calcular las dimensiones de la imagen resultante
    rf = imdim[1] - kerdim[1] + 1
    rc = imdim[2] - kerdim[2] + 1
    # Crear un array para guardar los resultados
    resultado = zeros(rf, rc, 4)
    # Aplicar la convolución
    for i in 1:rf
        for j in 1:rc
            # Extraer una submatriz de nxn de la imagen
            subim = img1[i:i+kerdim[1]-1, j:j+kerdim[2]-1]

            # Aplicar la convolución sobre GX
            resultado[i, j, 1] = sum(subim .* gxk)

            # Aplicar la convolución sobre GY
            resultado[i, j, 2] = sum(subim .* gyk)

            # Calcular el operador de Sobel
            sobel = sqrt(resultado[i, j, 1]^2 + resultado[i, j, 2]^2)

            # Guardar el valor del gradiente
            resultado[i, j, 3] = sobel
        end
    end
    #### Reportar las salidas ####
    # Reportar Gx
    rgx = resultado[:, :, 1]
    # Estandarizar
    minr = minimum(rgx)
    maxr = maximum(rgx)
    p1 = (rgx .- minr) ./ (maxr - minr)
    q1 = 1 .- p1
    # Reportar Gy
    rgy = resultado[:, :, 2]
    # Estandarizar
    minr = minimum(rgy)
    maxr = maximum(rgy)
    p2 = (rgy .- minr) ./ (maxr - minr)
    q2 = 1 .- p2
    # Reportar Sobel
    rg = resultado[:, :, 3]
    # Estandarizar
    minr = minimum(rg)
    maxr = maximum(rg)
    p3 = (rg .- minr) ./ (maxr - minr)
    q3 = 1 .- p3
    # Operador de la dirección
    resultado[:, :, 4] = atan.(resultado[:, :, 2], resultado[:, :, 1])
    q4 = resultado[:, :, 4] 
    # Normalizar el ángulo a [0, 1]
    q4 = (q4 .+ pi) ./ (2 * pi)
    # Exportar salidas
    return Gray.(q1), Gray.(q2), Gray.(q3), Gray.(q4)
end

# Obtener resultados #
# Ejemplo de uso
ruta = "Fig3.45(a).jpg"
q1, q2, q3, q4 = imsobel(ruta)
# Puedes guardar las imágenes o mostrarlas usando imshow
save("q1.png", q1)
save("q2.png", q2)
save("q3.png", q3)
save("q4.png", q4)


