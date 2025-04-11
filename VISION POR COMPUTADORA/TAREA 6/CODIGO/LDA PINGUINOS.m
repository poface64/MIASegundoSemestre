%% Cargar la base de datos en formato CSV %%
ruta = "penguins.csv";
datos = readtable(ruta); % Leer el archivo CSV en una tabla
size(datos); % Ver el tamaño de los datos

% 1 etiqueta de clasificación (Species)
% 3 características categóricas (Isla, sexo y año de observación)
% 4 variables continuas: bill length, bill depth, fliper y bodymass

% Filtrar solo las columnas numéricas y eliminar filas con datos faltantes
indices = find(any(isnan(datos{:, 4:7}), 2)); % Buscar filas con valores NaN en las columnas 4 a 7
datos1 = datos;
datos1(indices, :) = []; % Eliminar esas filas

% Extraer las variables numéricas y la especie para el gráfico
% Extraer las variables numéricas y la especie para el gráfico
especie = datos1.species; % Columna 'species' con las etiquetas de especies
% Convertir la columna 'especie' en un vector de tipo categorical
especie = categorical(especie); % Convertir a tipo categorical, que gscatter entiende
datos1 = table2array(datos1(:, 4:7)); % Convertir las columnas 4 a 7 a un arreglo numérico

%% Gráficos descriptivos %%
% Graficar el gráfico de dispersión usando gscatter
% Longitud del pico y ancho del pico
subplot(2,2,1)
gscatter(datos1(:,1), datos1(:,2), especie,"filled"); 
xlabel('Longitud del pico'); % Etiqueta del eje x
ylabel('Profundidad del pico'); % Etiqueta del eje y
title('G1'); % Título del gráfico

% Longitud del pico y longitud de la aleta %
subplot(2,2,2)
gscatter(datos1(:,1), datos1(:,3), especie,"filled");
xlabel('Longitud del pico'); % Etiqueta del eje x
ylabel('Longitud de la aleta'); % Etiqueta del eje y
title('G2'); % Título del gráfico
% Longitud del pico y masa corporal
subplot(2,2,3)
gscatter(datos1(:,1), datos1(:,4), especie,"filled");
xlabel('Longitud del pico'); % Etiqueta del eje x
ylabel('Masa corporal'); % Etiqueta del eje y
title('G3'); % Título del gráfico
% Ancho del pico y Longitud de la aleta
subplot(2,2,4)
gscatter(datos1(:,2), datos1(:,3), especie,"filled");
xlabel('Profundidad del pico'); % Etiqueta del eje x
ylabel('Longitud de la aleta'); % Etiqueta del eje y
title('G4'); % Título del gráfico

%% Exploración en 3D %&
% Crear un gráfico 3D
subplot(1,2,1)
scatter3(datos1(:,1), datos1(:,2), datos1(:,3), 50, especie, 'filled'); 
% Ajustar etiquetas y título
xlabel('Longitud del pico');
ylabel('Profundidad del pico');
zlabel('Longitud del aletín');
title('');

subplot(1,2,2)
scatter3(datos1(:,2), datos1(:,3), datos1(:,4), 50, especie, 'filled'); 
% Ajustar etiquetas y título
xlabel('Profundidad del pico');
ylabel('Largo de la aleta');
zlabel('Masa corporal');
title('');
% Mostrar la leyenda de colores
% Guardar como archivo PNG

%% FUNCIÓN LDA %%
function resu = LDA(X, Y)
    % Asegúrate de que X es una matriz
    X = double(X);    
    % Número de variables (columnas)
    nc = size(X, 2);
    % Clases únicas
    clas = unique(Y);
    nr = length(clas); % número de clases    
    % Inicializar matrices
    medias = zeros(nr, nc);
    Sw = zeros(nc, nc);
    for i = 1:nr
        % Subconjunto para la clase k-ésima
        mini1 = X(Y == clas(i), :);        
        % Vector de medias clase k
        medias(i, :) = mean(mini1, 1);        
        % Matriz de covarianza clase k
        centered = mini1 - medias(i, :);
        Sn = centered' * centered;        
        % Acumular la varianza dentro de clase
        Sw = Sw + Sn;
    end
    % Vector de medias global
    m = mean(X, 1);
    % Dispersión total
    centered_global = X - m;
    St = centered_global' * centered_global;
    % Matriz de dispersión entre clases
    Sb = St - Sw;
    % Matriz S = inv(Sw) * Sb
    S = inv(Sw) * Sb;
    % Eigenvalores y eigenvectores
    [V, D] = eig(S);
    [eigenvalues, idx] = sort(diag(D), 'descend');
    V = V(:, idx);
    % Varianza explicada
    VE = round(100 * eigenvalues / sum(eigenvalues), 4);
    % Filtrar vectores con varianza explicada significativa
    DS = VE > 0.0001;
    SV = V(:, DS);
    % Proyección de los datos
    Z = X * SV;
    % Renombrar las columnas
    for i = 1:size(Z, 2)
        colnames{i} = ['ND', num2str(i)];
    end
    % Armar resultado
    resu.varianza = VE;
    resu.coeficientes = SV;
    resu.proyecciones = array2table(Z, 'VariableNames', colnames);
end

%% Caso para 2 grupos (Adelie y Chinstrap)
X1 = datos1(Y ~= "Gentoo",:);
Y1 = especie(Y ~= "Gentoo");

%% Aplicar el LDA %%
salida1 = LDA(X1,Y1)
% Varianza explicada
salida1.varianza
% Vectores propios
salida1.coeficientes
% Proyecciones
Z1 = table2array(salida1.proyecciones);

%% Crear una dispersión en 1D (todos los puntos con la misma Y)
y = zeros(size(Z1, 1), 1); % Todos los puntos en Y=0
gscatter(Z1, y, Y1, 'rgb', '.', 15);
xlabel('ND1');
yticks([]); % Eliminar marcas del eje Y
ylabel('');
title('');

%% Caso para 3 grupos (Adelie, Chinstrap y Gentoo)
X2 = datos1;
Y2 = especie;
%% Aplicar el LDA %%
salida2 = LDA(X2,Y2)
% Varianza explicada
salida2.varianza
% Vectores propios
salida2.coeficientes
% Proyecciones
Z2 = table2array(salida2.proyecciones) 

%% Gráficar en 2D %%
gscatter(Z2(:,1), Z2(:,2), Y2,"filled");
xlabel('ND1'); % Etiqueta del eje x
ylabel('ND2'); % Etiqueta del eje y
title(''); % Título del gráfico












