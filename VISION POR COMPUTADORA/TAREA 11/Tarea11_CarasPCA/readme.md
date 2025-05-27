**Los archivos importantes son generar_rostro_GUI.m y pca_faces.m** 

*pca_faces.m* muestra como se utilizó la función PCA nativa de Matlab para generar el modelo estadístico de forma utilizando las 100 caras más parecidas a la primera en la base de datos.  Además, permite visualizar la distribución de cada uno de los 4 parámetros que se pueden ajustar en el modelo. **Importante:** Necesita el archivo *BIOID_0001.pgm*.

*generar_rostro_GUI.m* es la interfaz gráfica que permite generar rostros ajustando los parámetros necesarios. Sigue las indicaciones de la tarea. **Importante:** necesita de los archivos *faces_mean.mat, faces_eigenvecs.mat, alphas_caras.mat*

*faces_mean.mat, faces_eigenvecs.mat* son datos que se obtuvieron con las 100 caras y con la función *pca_faces.m*. Estos son los que permiten crear el modelo.

*alphas_caras.mat* son los parámetros de ajuste de las 100 carasm utilizadas para encontrar los límites de los sliders en la interfaz gráfica.

*best_faces.mat* son las 100 caras seleccionadas de la base de datos.

*graph_contorno_cara.m* es una función de prueba, la primera implementación para la graficación de los rostros.

*cara_contonos.png, puntos_indices.png* son imágenes para el reporte.
