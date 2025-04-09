function propina = sistemaSugeno(comida, servicio)
%  Parámetros:
%   - servicio entre 0 y 10 que califica la calidad del servicio
%   - comida entre 0 y 100 que califica la calidad de la comida
%  Salida: propina (0-20)

    %% PASO 1: Definir función de membresía triangular
    trimf = @(x, a, b, c) max(min((x-a)/(b-a), (c-x)/(c-b)), 0);
    
    %% PASO 2: Calcular los grados de pertenencia para SERVICIO
    % Calcula cuánto pertenece el valor de servicio a cada categoría
    servicioMalo    = trimf(servicio, 0, 0, 5);      % Servicio Malo [0,0,5]
    servicioRegular = trimf(servicio, 0.8333, 5, 9.167);  % Servicio Regular [0.83,5,9.17]
    servicioBueno   = trimf(servicio, 4, 10, 10);    % Servicio Bueno [4,10,10]
    % Almacenar todos los valores de pertenencia para servicio
    servicioMF = [servicioMalo, servicioRegular, servicioBueno];
    
    %% PASO 3: Calcular los grados de pertenencia para COMIDA
    comidaMala      = trimf(comida, 0, 0, 45);       % Comida Mala [0,0,45]
    comidaNormal    = trimf(comida, 15, 45, 80);     % Comida Normal [15,45,80]
    comidaBuena     = trimf(comida, 40, 70, 95);     % Comida Buena [40,70,95]
    comidaExcelente = trimf(comida, 60, 100, 100);   % Comida Excelente [60,100,100]
    % Almacenar todos los valores de pertenencia para comida
    comidaMF = [comidaMala, comidaNormal, comidaBuena, comidaExcelente];
    
    %% PASO 4: Definir reglas y valores de salida para cada regla
    % Reglas en formato [Servicio, Comida] donde cada número representa el índice
    % de la categoría correspondiente (1:Malo/Mala, 2:Regular/Normal, etc.)
    reglas = [
        1, 1;  % Servicio Malo + Comida Mala 
        3, 2;  % Servicio Bueno + Comida Normal
        2, 2;  % Servicio Regular + Comida Normal
        2, 3;  % Servicio Regular + Comida Buena
        3, 4;  % Servicio Bueno + Comida Excelente
        1, 4;  % Servicio Malo + Comida Excelente
        3, 1;  % Servicio Bueno + Comida Mala
        1, 2;  % Servicio Malo + Comida Normal
        1, 3;  % Servicio Malo + Comida Buena
        3, 3;  % Servicio Bueno + Comida Buena
        2, 1;  % Servicio Regular + Comida Mala
        2, 4;  % Servicio Regular + Comida Excelente
    ];
    
    % Valores constantes de salida para cada regla (propinas correspondientes)
    salidas = [0, 12, 12, 12, 20, 5, 5, 5, 5, 20, 5, 20];
    
    %% PASO 5: Evaluar cada regla y calcular su peso (activación)
    % Vector para almacenar el peso (nivel de activación) de cada regla
    pesos = zeros(1, length(salidas));
    
    % Evaluar cada regla usando el operador AND (multiplicación)
    for i = 1:length(salidas)
        % Obtener índices para servicio y comida según la regla actual
        indice_servicio = reglas(i, 1);
        indice_comida = reglas(i, 2);       
        % Calcular el peso multiplicando los grados de pertenencia (AND lógico)
        pesos(i) = servicioMF(indice_servicio) * comidaMF(indice_comida);
    end
    
    %% PASO 6: Defuzzificación mediante media ponderada (método Sugeno)
    % Calcular propina como media ponderada (suma(peso*salida)/suma(pesos))
    if sum(pesos) == 0
        % Si ninguna regla se activa, la propina es 0
        propina = 0;
    else
        % Media ponderada de las salidas según la activación de cada regla
        propina = sum(pesos .* salidas) / sum(pesos);
    end
end

%% Caso minimo %%
sistemaSugeno(0, 0)

%% Caso intermedio %%
sistemaSugeno(50,5 )

%% Caso intermedio %%
sistemaSugeno(100, 10)
