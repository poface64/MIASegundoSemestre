
%% Parametros para propar la salida %%
SER = 8
COM = 20



%% Definir la función Gaussiana %%
function salida = gauss(x,mu,S)
       salida = exp(-((x-mu)^2)/(S^2));
end

%% Función principal del problema del mesero %%
function resu = mesero(SER,COM)
    %%% Definir los niveles de comida %%
%propina_valor = 0;
propina_baja = 0;
propina_normal = 0;
propina_alta = 0;
propina_excelente = 0;

%%% DEFINICION DE FUNCIONES DE MEMBRESIA %% 
%%% FUNCIONES DE MEMBRESIA PARA SERVICIO  %%% 

%Funciones de membresia servicio%
% Servicio malo %
servicio_malo = gauss(SER,1.5,2);
% Servicio regular% 
servicio_regular = gauss(SER,5,1.5);
% Servicio bueno% 
servicio_bueno = gauss(SER,7.5,1.5);

%%% FUNCIONES DE MEMBRESIA PARA COMIDA  %%% 
%Funciones de membresia servicio%
% Comida mala %
comida_mala = gauss(COM,15,15);
% Comida normal %
comida_normal = gauss(COM,45,15);
% Comida buena %
comida_buena = gauss(COM,66,10);
% Comida excelente %
comida_excelente = gauss(COM,90,15);

%%% Funciones de membresia para propina %%%
%PROP = 13
% Propina Baja %
%propina_baja = gauss(PROP,5.5,3)
% Propina Normal %
%propina_normal = gauss(PROP,12,3)
% Propina Buena %
%propina_alta = gauss(PROP,18,2.5)

%%% DEFINICION DE REGLAS DEL SISTEMA %%
% Base de datos del conocimiento $
% Usar el operador AND y usar el minimo %

Singletons = [5, 12,12,12,16,5,5, 5,5,16,5,16];
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

% Definir el vector con las reglas
reglasV = [regla1 regla2 regla3 regla4 regla5 regla6 regla7 ...
            regla8 regla9 regla10 regla11 regla12];
%%% Aplicar el centro de masa para defuzzificar %%%%
SumaW = sum(reglasV);
resu = sum(Singletons.*reglasV)/SumaW;
end

%%%% Corridas de prueba
mesero(0,0) %%% Caso minimo
mesero(4,52)%%% Caso medio
mesero(10,100)%%% Caso Alto


%%%% Salidas 
ENTRADAS

3 CORRIDAS

Valores minimos
Valores medios
Valores maximos


Problema 1

SERVICIO [0 A 10]
Malo
mu = 1.5
s = 2
Regular
mu = 5
s = 1.5
Bueno
mu = 7.5
s = 1.5

COMIDA [0 A 100]
Mala
mu = 15
s = 15
Normal
mu = 45.5
s = 15
Buena
mu = 66
s = 10
Excelente
mu = 90
s = 15

PROPINA [0 a 20]
BAJA
SINGLE = 5
NORMAL
SINGLE = 12
ALTA
SINGLE = 16
