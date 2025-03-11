%% Parametros para probar la salida %%
%SER = 8;
%COM = 20;

%% Definir la función Gaussiana %%
% Nota: Expandida para tolerar la manipulación de vectores
function salida = gauss(x,mu,S)
       salida = exp(-((x-mu).^2)/(2*S^2));
end

%% Función principal del problema del mesero %%
function resu = mesero(SER,COM)
    %%% Definir los niveles de propina %%
    propina_baja = 0;
    propina_normal = 0;
    propina_alta = 0;
    
    %%% DEFINICION DE FUNCIONES DE MEMBRESIA %% 
    %%% SERVICIO  %%% 
    servicio_malo = gauss(SER,1.5,2);
    servicio_regular = gauss(SER,5,1.5);
    servicio_bueno = gauss(SER,7.5,1.5);
    
    %%% COMIDA  %%% 
    comida_mala = gauss(COM,15,15);
    comida_normal = gauss(COM,45,15);
    comida_buena = gauss(COM,66,10);
    comida_excelente = gauss(COM,90,15);

    %%% REGLAS DIFUSAS %%
    % 1.- servicio "malo" y comida "mala", propina es "Baja".
    regla1 = min(servicio_malo, comida_mala); 
    % 2. servicio es "bueno" y comida "normal", propina es "Normal".
    regla2 = min(servicio_bueno, comida_normal);
    % 3. servicio "regular" y comida "normal", propina es "Normal".
    regla3 = min(servicio_regular, comida_normal);
    % 4. servicio es "regular" y comida es "buena",propina es "Normal".
    regla4 = min(servicio_regular, comida_buena);
    % 5. servicio es "bueno" y comida es "excelente", propina es "Alta".
    regla5 = min(servicio_bueno, comida_excelente);
    % 6. servicio es "malo" y comida es "excelente", propina es "Baja".
    regla6 = min(servicio_malo, comida_excelente);
    % 7. servicio "bueno" y comida "mala", propina es "Baja".
    regla7 = min(servicio_bueno, comida_mala);
    % 8. servicio "malo" y comida es "normal", propina es "Baja".
    regla8 = min(servicio_malo, comida_normal);
    % 9. servicio es "malo" y comida "buena", propina es "Baja".
    regla9 = min(servicio_malo, comida_buena);
    % 10. servicio es "bueno" y comida es "buena",  propina es "Alta".
    regla10 = min(servicio_bueno, comida_buena);
    % 11. servicio "regular" y comida "mala", propina es "Baja".
    regla11 = min(servicio_regular, comida_mala);
    % 12. servicio es "regular" y comida "excelente", propina es "Alta".
    regla12 = min(servicio_regular, comida_excelente);

    %%% Procesar para la salida %%
    % Definir el vector de reglas %
    reglasV = [regla1 regla2 regla3 regla4 regla5 regla6 regla7 ...
               regla8 regla9 regla10 regla11 regla12];
    
    %%% Definir la variable de salida (propina) en un rango continuo %%
    x = linspace(0, 20, 10000);  % Valores de propina de 0 a 20
    
    %%% Calcular las funciones de membresía para la propina
    propina_baja = gauss(x, 5, 2);    % mu = 5, s = 2
    propina_normal = gauss(x, 10, 2); % mu = 10, s = 2
    propina_alta = gauss(x, 16, 1.5); % mu = 16, s = 1.5
    
    %%% Ponderar las funciones de membresía con las reglas
    propina_agregada = max([reglasV(1) * propina_baja;
                            reglasV(2) * propina_normal;
                            reglasV(3) * propina_normal;
                            reglasV(4) * propina_normal;
                            reglasV(5) * propina_alta;
                            reglasV(6) * propina_baja;
                            reglasV(7) * propina_baja;
                            reglasV(8) * propina_baja;
                            reglasV(9) * propina_baja;
                            reglasV(10) * propina_alta;
                            reglasV(11) * propina_baja;
                            reglasV(12) * propina_alta]);
    
    %%% Defuzzificación por el método del centroide %%%
    numerador = sum(x .* propina_agregada);
    denominador = sum(propina_agregada);
    %%% Salida y verificación que no ocurra división por 0 %%%
    if denominador == 0
        resu = 0; % Evita la división por cero
    else
        resu = numerador / denominador;
    end
end

%%%% Corridas de prueba
mesero(0,0) %%% Caso mínimo
mesero(4,52)%%% Caso medio
mesero(10,100)%%% Caso Alto


