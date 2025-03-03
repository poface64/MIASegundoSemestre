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
%Funciones de membresia servicio%
% Servicio malo %
if (servicio_calidad>4)
servicio_malo=0;
elseif (servicio_calidad>=0 && servicio_calidad<=4)
servicio_malo=1;
elseif (servicio_calidad>3.5 && servicio_calidad<8)
servicio_malo=(4-servicio_calidad)/3;
end

% Servicio regular% 
servicio_regular=exp(-(servicio_calidad-6)^2);

% Servicio bueno %
if (servicio_calidad<4)
servicio_bueno=0;
elseif (servicio_calidad>=0 && servicio_calidad<= 3)
servicio_bueno=(servicio_calidad-7)/2;
elseif (servicio_calidad>9)
servicio_bueno=1;
end

%% Funciones de membresia para comida %%
  
% Comida mala%
if (comida_calidad>30)
comida_mala =0;
elseif (comida_calidad>=0 && comida_calidad<=25)
comida_mala=1;
elseif (comida_calidad>25 && comida_calidad<30)
comida_mala=(50-comida_calidad)/36;
end

% Comida normal% 
comida_normal=exp(-(comida_calidad-50)^2 / 9.5^2);
% Comida buena% 
comida_buena=exp(-(comida_calidad-75)^2 / 8^2);

% Comida excelente%
if (comida_calidad<80)
comida_excelente=0;
elseif (comida_calidad>=80 && comida_calidad<= 100)
comida_excelente=(comida_calidad-80)/20;
end

%Funciones de membresia para propina%
  
% Propina baja%
if propina_valor == 5
propina_baja = 1;
end

% Propina normal%
  if propina_valor == 10
propina_normal=1;
end

% Propina alta%
if propina_valor == 15
propina_alta=1;
end

% Propina excelente%
if propina_valor == 20
propina_excelente=1;
end

  
%% DEFINICION DE REGLAS DEL SISTEMA %%
% Base de datos del conocimiento $
% Usar el operador AND y usar el minimo %
% 1.- servicio "malo" y comida "mala", propina es "baja".
regla1 = min(servicio_malo, comida_mala); 
% 2. servicio "regular" y comida "mala", propina es "baja".
regla2 = min(servicio_regular, comida_mala);
% 3. servicio "bueno" y comida "mala", propina es "normal".
regla3 = min(servicio_bueno, comida_mala);
% 4. servicio "malo" y comida es "normal", propina es "baja".
regla4 = min(servicio_malo, comida_normal);
% 5. servicio "regular" y comida "normal", propina es "normal".
regla5 = min(servicio_regular, comida_normal);
% 6. servicio es "bueno" y comida "normal", propina es "alta".
regla6 = min(servicio_bueno, comida_normal);
% 7. servicio es "malo" y comida "buena", propina es "normal".
regla7 = min(servicio_malo, comida_buena);
% 8. servicio es "regular" y comida es "buena",propina es "normal".
regla8 = min(servicio_regular, comida_buena);
% 9. servicio es "bueno" y comida es "buena",  propina es "alta".
regla9 = min(servicio_bueno, comida_buena);
% 10. servicio es "malo" y comida es "excelente", propina es "normal".
regla10 = min(servicio_malo, comida_excelente);
% 11. servicio es "regular" y comida "excelente", propina es "excelente".
regla11 = min(servicio_regular, comida_excelente);
% 12. servicio es "bueno" y comida es "excelente", propina es "excelente".
regla12 = min(servicio_bueno, comida_excelente);




