
%% Definir la función Gaussiana %%
function salida = gauss(x,mu,S)
       salida = exp(-((x-mu)^2)/(S^2));
end

%% Función principal del problema del confort termico %%
function resu = confort(TEMP,HUMEDAD)
    %%% Definir los niveles de Confort %%
    Confort_Malo = 0;
    Confort_Incomodo = 0;
    Confort_Comodo = 0;
    
    %%% DEFINICION DE FUNCIONES DE MEMBRESIA %% 
    %%% FUNCIONES DE MEMBRESIA PARA TEMPERATURA  %%% 
    
    %Funciones de membresia temperatura%
    % Temperatura Frio %
    temperatura_Frio = gauss(TEMP,0,3);
    % Temperatura Fresco %
    temperatura_Fresco = gauss(TEMP,11,3);
    % Temperatura Idoneo %
    temperatura_Idoneo = gauss(TEMP,18,2.25);
    % Temperatura Calurosa %
    temperatura_Calurosa = gauss(TEMP,26,3);
    
    %%% FUNCIONES DE MEMBRESIA PARA HUMEDAD  %%% 
    %Funciones de membresia servicio%
    % Humedad BAJA %
    Humedad_Baja = gauss(HUMEDAD,20,10);
    % Humedad MEDIA %
    Humedad_Media = gauss(HUMEDAD,40,15);
    % Humedad ALTA %
    Humedad_Alta = gauss(HUMEDAD,80,15);
    
    
    %%% DEFINICION DE REGLAS DEL SISTEMA %%
    % Base de datos del conocimiento $
    % Usar el operador AND y usar el minimo %
    
    Singletons = [4,8,8,8,2,...
                  4,4,2,4,2];
    
    % 1. Temperatura "Frio" y Humedad "Baja", Confort es "Incomodo".
    regla1 = min(temperatura_Frio, Humedad_Baja); 
    % 2. Temperatura es "Fresco" y Humedad "Baja", Confort es "Comoda".
    regla2 = min(temperatura_Fresco, Humedad_Baja);
    % 3. Temperatura "Idonea" y Humedad "Baja", Confort es "Comoda".
    regla3 = min(temperatura_Idoneo ,Humedad_Baja);
    % 4. Temperatura es "Frio" y Humedad es "Media",Confort es "Comoda".
    regla4 = min(temperatura_Frio ,Humedad_Media);
    % 5. Temperatura es "Idoneo" y Humedad es "Media", Confort es "Mala".
    regla5 = min(temperatura_Idoneo ,Humedad_Media);
    % 6. Temperatura es "Frio" y Humedad es "Baja", Confort es "Incomoda".
    regla6 = min(temperatura_Frio ,Humedad_Baja);
    % 7. Temperatura "Idoneo" y Humedad "Alta", Confort es "Incomoda".
    regla7 = min(temperatura_Idoneo ,Humedad_Alta);
    % 8. Temperatura "Caluroso" y Humedad es "Baja", Confort es "Mala".
    regla8 = min(temperatura_Calurosa ,Humedad_Baja);
    % 9. Temperatura es "Calurosa" y Humedad "Media", Confort es "Incomoda".
    regla9 = min(temperatura_Calurosa ,Humedad_Media);
    % 10. Temperatura es "Calurosa" y Humedad es "Alta",  Confort es "Mala".
    regla10 = min(temperatura_Calurosa ,Humedad_Alta);
    
    %%% Procesar para la salida %%
    
    % Definir el vector con las reglas
    reglasV = [regla1 regla2 regla3 regla4 regla5 regla6 regla7 ...
                regla8 regla9 regla10];
    %%% Aplicar el centro de masa para defuzzificar %%%%
    SumaW = sum(reglasV);
    resu = sum(Singletons.*reglasV)/SumaW ;
end

%% Corridas de prueba %%
confort(0,0) %%% Caso minimo
confort(15,50)%%% Caso medio
confort(30,100)%%% Caso Alto


