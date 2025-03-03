%% Definir la función Gaussiana %%
function salida = gauss(x,mu,S)
    salida = exp(-((x-mu)^2)/2*S^2 );
end


%% Definir los niveles de servicio %%
servicio_malo = 0;
servicio_regular = 0;
servicio_bueno = 0;

%% Definir los niveles de comida %%
comida_mala = 0;
comida_normal = 0;
comida_buena = 0;
comida_excelente = 0;

%% Definir los niveles de comida %%
%propina_valor = 0;
propina_baja = 0;
propina_normal = 0;
propina_alta = 0;
propina_excelente = 0;

%% DEFINICION DE FUNCIONES DE MEMBRESIA %% 
%%% FUNCIONES DE MEMBRESIA PARA SERVICIO  %%% 

%Funciones de membresia servicio%
SER = 6.5
% Servicio malo %
servicio_malo = gauss(SER,1.5,2)
% Servicio regular% 
servicio_regular = gauss(SER,5,1.5)
% Servicio bueno% 
servicio_bueno = gauss(SER,7.5,1.5)

%%% FUNCIONES DE MEMBRESIA PARA COMIDA  %%% 
%Funciones de membresia servicio%
COM = 60
% Comida mala %
comida_mala = gauss(COM,15,15)
% Comida normal %
comida_normal = gauss(COM,45,15)
% Comida buena %
comida_buena = gauss(COM,66,10)
% Comida excelente %
comida_excelente = gauss(COM,90,15)



