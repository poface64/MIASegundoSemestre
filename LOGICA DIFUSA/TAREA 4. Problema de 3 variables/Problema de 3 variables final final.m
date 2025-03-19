%% Función Gaussiana %%
function salida = gauss(x, mu, S)
    salida = exp(-((x - mu).^2) / (2 * S^2));
end

%% Función principal del sistema difuso de calificación de juegos %%
function calificacion = evaluar_juego(JUG, GRAF, HIST)
    %%% Definir funciones de membresía %%%
    % Jugabilidad
    jug_mala = gauss(JUG, 25, 10);
    jug_regular = gauss(JUG, 60, 10);
    jug_buena = gauss(JUG, 80, 10);
    
    % Gráficos
    graf_malos = gauss(GRAF, 20, 15);
    graf_decente = gauss(GRAF, 50, 10);
    graf_excelente = gauss(GRAF, 80, 15);
    
    % Historia
    hist_pesima = gauss(HIST, 20, 15);
    hist_pasable = gauss(HIST, 60, 12);
    hist_excelente = gauss(HIST, 85, 10);
    
    %%% Reglas difusas %%%
    reglas = [
        min([jug_mala, graf_malos, hist_pesima]); % Pesimo
        min([jug_mala, graf_malos, hist_pasable]); % Pesimo
        min([jug_mala, graf_malos, hist_excelente]); % Pesimo
        min([jug_mala, graf_decente, hist_pesima]); % Pesimo
        min([jug_mala, graf_decente, hist_pasable]); % Pesimo
        min([jug_mala, graf_decente, hist_excelente]); % Pasable
        min([jug_mala, graf_excelente, hist_pesima]); % Pesimo
        min([jug_mala, graf_excelente, hist_pasable]); % Pasable
        min([jug_mala, graf_excelente, hist_excelente]); % Pasable
        min([jug_regular, graf_malos, hist_pesima]); % Pesimo
        min([jug_regular, graf_malos, hist_pasable]); % Pasable
        min([jug_regular, graf_malos, hist_excelente]); % Pasable
        min([jug_regular, graf_decente, hist_pesima]); % Pasable
        min([jug_regular, graf_decente, hist_pasable]); % Pasable
        min([jug_regular, graf_decente, hist_excelente]); % Excelente
        min([jug_regular, graf_excelente, hist_pesima]); % Pasable
        min([jug_regular, graf_excelente, hist_pasable]); % Excelente
        min([jug_regular, graf_excelente, hist_excelente]); % Excelente
        min([jug_buena, graf_malos, hist_pesima]); % Pasable
        min([jug_buena, graf_malos, hist_pasable]); % Pasable
        min([jug_buena, graf_malos, hist_excelente]); % Pasable
        min([jug_buena, graf_decente, hist_pesima]); % Pasable
        min([jug_buena, graf_decente, hist_pasable]); % Excelente
        min([jug_buena, graf_decente, hist_excelente]); % Excelente
        min([jug_buena, graf_excelente, hist_pesima]); % Pasable
        min([jug_buena, graf_excelente, hist_pasable]); % Excelente
        min([jug_buena, graf_excelente, hist_excelente]); % Excelente
    ];
    
    %%% Definir la variable de salida (calificación) %%%
    x = linspace(0, 100, 10000);
    calificacion_pesima = gauss(x, 20, 15);
    calificacion_pasable = gauss(x, 55, 12);
    calificacion_excelente = gauss(x, 85, 10);
    
    %%% Agregación de reglas %%%
    calificacion_agregada = max([
        reglas(1) * calificacion_pesima;
        reglas(2) * calificacion_pesima;
        reglas(3) * calificacion_pesima;
        reglas(4) * calificacion_pesima;
        reglas(5) * calificacion_pesima;
        reglas(6) * calificacion_pasable;
        reglas(7) * calificacion_pesima;
        reglas(8) * calificacion_pasable;
        reglas(9) * calificacion_pasable;
        reglas(10) * calificacion_pesima;
        reglas(11) * calificacion_pasable;
        reglas(12) * calificacion_pasable;
        reglas(13) * calificacion_pasable;
        reglas(14) * calificacion_pasable;
        reglas(15) * calificacion_excelente;
        reglas(16) * calificacion_pasable;
        reglas(17) * calificacion_excelente;
        reglas(18) * calificacion_excelente;
        reglas(19) * calificacion_pasable;
        reglas(20) * calificacion_pasable;
        reglas(21) * calificacion_pasable;
        reglas(22) * calificacion_pasable;
        reglas(23) * calificacion_excelente;
        reglas(24) * calificacion_excelente;
        reglas(25) * calificacion_pasable;
        reglas(26) * calificacion_excelente;
        reglas(27) * calificacion_excelente;
    ]);
    
    %%% Defuzzificación (Centroide) %%%
    numerador = sum(x .* calificacion_agregada);
    denominador = sum(calificacion_agregada);
    
    if denominador == 0
        calificacion = 0;
    else
        calificacion = numerador / denominador;
    end
end

%%%% Pruebas %%%%
evaluar_juego(0, 0, 0)  % Caso mínimo
evaluar_juego(50, 50, 50)  % Caso medio
evaluar_juego(100, 100, 100)  % Caso máximo