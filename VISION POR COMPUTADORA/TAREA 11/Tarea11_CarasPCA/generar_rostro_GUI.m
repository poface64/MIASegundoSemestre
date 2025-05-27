function generar_rostro_GUI
    % Cargar datos
    load("faces_eigenvecs.mat", "pcV")
    load("faces_mean.mat", "mu")
    load("alphas_caras.mat", "alphas")

    % Crear figura sobre la que se graficará el rostroa
    f = figure('Name', 'Generar rostros con modelo estadístico de forma', ...
        'Units', 'normalized', 'OuterPosition', [0 0 1 1], ...
        'NumberTitle','off');


    % Se muestra el primer rostro como base de la interfaz
    ax = axes('Parent', f, 'Position',[0.05 0.1 0.35 0.8]);
    cara1 = imread("BioID_0001.pgm");

    % Iniciar los parámetros ajustados a la cara de fondo
    alpha = [-7.7409,-3.4482,3.420,-3.3884,3.2423,-0.5002,3.7840, ...
             2.8480,-0.2839,0.2117,-0.285,2.4314];

    % Los límites de cada parámetro están dados por los máximos y mínimos
    % encontrados en el PCA de las 100 imágenes
    mins = min(alphas, [], 1);
    maxs = max(alphas, [], 1);

    % Generar rostro mediante PCA
    new_face = alpha * pcV' + mu;
    graph_face(new_face);

    % Número de parámetros
    N = numel(alpha);

    % Espaciado horizontal entre controles
    spacing = 0.04;
    base_x = 0.45;

    % Crear botones deslizables para ajustar parámetros alpha
    sliders = gobjects(1,N);
    % Cajas de texto para ajustar parámetros alfa
    edit_boxes = gobjects(1,N);

    for i = 1:N
        x_pos = base_x + (i-1) * spacing;

        % Texto con número de parámetro alpha
        uicontrol(f, 'Style', 'text', ...
            'Units', 'normalized', ...
            'Position', [x_pos 0.92 0.035 0.04], ...
            'String', sprintf('Alfa %d', i), ...
            'FontSize', 9);

        % Barras deslizantes para manipular el valor del parámetro 
        sliders(i) = uicontrol(f, 'Style', 'slider', ...
            'Units', 'normalized', ...
            'Min', mins(i), 'Max', maxs(i), ...
            'Value', alpha(i), ...
            'SliderStep', [0.01 0.1], ...
            'Position', [x_pos+0.005 0.32 0.015 0.55], ...
            'Callback', @(src,~) sliderCallback(i));

        % Cajas de texto editable para mostrar el valor actual del parámetro o 
        % para ajustarlo de forma exacta
        edit_boxes(i) = uicontrol(f, 'Style', 'edit', ...
            'Units', 'normalized', ...
            'Position', [x_pos 0.24 0.035 0.04], ...
            'String', num2str(alpha(i), '%.2f'), ...
            'Callback', @(src,~) editCallback(i));

        % Texto con rango mínimo y máximo
        uicontrol(f, 'Style', 'text', ...
            'Units', 'normalized', ...
            'Position', [x_pos 0.18 0.04 0.04], ...
            'String', sprintf('[%.1f, %.1f]', mins(i), maxs(i)), ...
            'FontSize', 8);
    end

    % Actualización de la cara cuando se ajustan los parámetros en
    % la interfaz

    % Actualización cuando se mueve una barra deslizante
    function sliderCallback(i)
        alpha(i) = sliders(i).Value; % Re-evaluar parámetro alfa
        edit_boxes(i).String = sprintf('%.2f', alpha(i)); % Ajustar cajas de texto
        actualizar_rostro(); % Encontrar nuevo rostro
    end

    % Actualización cuando se alteran las cajas de texto
    function editCallback(i)
        val = str2double(edit_boxes(i).String);  % obtener valor numérico del texto
        if isnan(val), return; end  % Error si no es un número
        val = max(mins(i), min(maxs(i), val));  % Limitar al rango adecuado
        alpha(i) = val;  % Actualizar alfa
        sliders(i).Value = val; % Actualizar barra deslizante
        edit_boxes(i).String = sprintf('%.2f', val); % Actualizar caja de texto
        actualizar_rostro(); % Graficar nueva cara
    end

    % Actualizar rostro generado
    function actualizar_rostro()
        new_face = alpha * pcV' + mu;
        graph_face(new_face);
    end

    % Función para graficar la cara dada lista de coordenadas (1x40)
    function graph_face(point_list)
        cla(ax); % Limpiar imagen
        imshow(cara1, 'Parent', ax); % Volver a graficar rostro
        hold(ax, "on");

        points = reshape(point_list, 2, [])'; % Darle forma de matriz a los 
                                              % puntos (20, 2)

        % Struct donde se indica a que parte del cuerpo pertenece cada
        % índice
        partes = {
            [3, 18, 4, 19, 3], 'Labios';
            [10, 1, 11, 10], 'Ojo Izquierdo';
            [12, 2, 13, 12], 'Ojo Derecho';
            [16, 15, 17, 16], 'Nariz';
            [20, 14, 8, 7, 6, 5, 9, 20], 'Contorno'
        };
        
        % Se grafica cada parte del cuerpo, uniendo los puntos 
        for k = 1:size(partes,1)
            idx = partes{k,1};
            plot(ax, points(idx,1), points(idx,2), 'r.-', 'DisplayName', partes{k,2});
        end
        hold(ax, "off");
    end
end
