%% Parametros para la salida %% 
JUG = 70;  % Calificación
GRAF = 70
HIST = 70


%% Definir la función Gaussiana %%
function salida = gauss(x, mu, S)
       salida = exp(-((x - mu)^2) / (S^2));
end

%% Función principal del problema de calificación de videojuegos %%
function resu = juegos(JUG,GRAF,HIST)


%%% Definir los niveles de calificación %% 
calificacion_pesima = 0;
calificacion_pasable = 0;
calificacion_excelente = 0;

%%% DEFINICION DE FUNCIONES DE MEMBRESIA %%
%%% FUNCIONES DE MEMBRESIA PARA JUGABILIDAD %%%
% Jugabilidad Mala %
jugabilidad_mala = gauss(JUG, 25, 10);  
% Jugabilidad Regular %
jugabilidad_regular = gauss(JUG, 60, 10);  
% Jugabilidad Buena %
jugabilidad_buena = gauss(JUG, 80, 10);

%%% FUNCIONES DE MEMBRESIA PARA GRAFICOS %%
% Graficos Malos %
graficos_malos = gauss(GRAF, 20, 15);
% Graficos Decentes %
graficos_decentes = gauss(GRAF, 50, 10);
% Graficos Excelentes %
graficos_excelentes = gauss(GRAF, 80, 15);

%%% FUNCIONES DE MEMBRESIA PARA HISTORIA %%
% Historia Pesima %
historia_pesima = gauss(HIST, 30, 15);
% Historia Pasable %
historia_pasable = gauss(HIST, 70, 15);
% Historia Excelente %
historia_excelente = gauss(HIST, 85, 10);

%%% FUNCIONES DE MEMBRESIA PARA CALIFICACION %%
% Calificación Pesima %
%calificacion_pesima = gauss(CAL, 45, 15);
% Calificación Pasable %
%calificacion_pasable = gauss(CAL, 70, 10);
% Calificación Excelente %
%calificacion_excelente = gauss(CAL, 85, 10);


%%% DEFINICION DE REGLAS DEL SISTEMA %%%
% 1. Juga MALA y Gráficos Malos y Historia Pésima → Calificación Pésima
regla1 = min(jugabilidad_mala, min(graficos_malos, historia_pesima));
% 2. Juga MALA y Gráficos Decentes y Historia Pasable → Calificación Pésima
regla2 = min(jugabilidad_mala, min(graficos_decentes, historia_pasable));
% 3. Juga MALA y Gráficos Excelentes y Historia Pasable → Calificación Pésima
regla3 = min(jugabilidad_mala, min(graficos_excelentes, historia_pasable));
% 4. Juga MALA y Gráficos Excelentes y Historia Excelente → Calificación Pasable
regla4 = min(jugabilidad_mala, min(graficos_excelentes, historia_excelente));
% 5. Juga Regular y Gráficos Malos y Historia Pésima → Calificación Pésima
regla5 = min(jugabilidad_regular, min(graficos_malos, historia_pesima));
% 6. Juga Regular y Gráficos Decentes y Historia Pésima → Calificación Pasable
regla6 = min(jugabilidad_regular, min(graficos_decentes, historia_pesima));
% 7. Juga Regular y Gráficos Excelentes y Historia Pésima → Calificación Pasable
regla7 = min(jugabilidad_regular, min(graficos_excelentes, historia_pesima));
% 8. Juga Regular y Gráficos Excelentes y Historia Regular → Calificación Excelente
regla8 = min(jugabilidad_regular, min(graficos_excelentes, historia_pasable));
% 9. Juga Excelente y Gráficos Malos y Historia Pésima → Calificación Pasable
regla9 = min(jugabilidad_buena, min(graficos_malos, historia_pesima));
% 10. Juga Excelente y Gráficos Decentes y Historia Pésima → Calificación Pasable
regla10 = min(jugabilidad_buena, min(graficos_decentes, historia_pesima));
% 11. Juga Excelente y Gráficos Excelentes y Historia Pésima → Calificación Pasable
regla11 = min(jugabilidad_buena, min(graficos_excelentes, historia_pesima));
% 12. Juga Excelente y Gráficos Excelentes y Historia Regular → Calificación Excelente
regla12 = min(jugabilidad_buena, min(graficos_excelentes, historia_pasable));
% 13. Juga Excelente y Gráficos Excelentes y Historia Excelente → Calificación Excelente
regla13 = min(jugabilidad_buena, min(graficos_excelentes, historia_excelente));

Singletons = [50,  50, 50, 75, 50, 75, 75, 100, 75, 75, 75, 100, 100];

%%% Procesar para la salida %%
% Definir el vector con las reglas
reglasV = [regla1 regla2 regla3 regla4 regla5 regla6 regla7 ...
            regla8 regla9 regla10 regla11 regla12 regla13];
%%% Aplicar el centro de masa para defuzzificar %%%%
SumaW = sum(reglasV);
resu = sum(Singletons.*reglasV)/SumaW;
end


juegos(45,10,90)
