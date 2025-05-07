clear all;
clc;

servicio = 9;
comida = 59;

servicio_malo = 0;
servicio_regular = 0;
servicio_bueno = 0;
servicio_excelente = 0;

comida_mala = 0;
comida_normal = 0;
comida_buena = 0;
comida_excelente = 0;

propina = 0;

%-------------------- SERVCIO ------------------------
if ((servicio < 0))
    servicio_malo = 0;
elseif ((servicio >= 0) && (servicio <= 1.5))
        servicio_malo = 1;
elseif ( (servicio >= 1.5) && (servicio <= 3))
            servicio_malo = (3 - servicio) / (3 - 1.5);
end

if ((servicio >= 1.5) && (servicio <= 2.5))
    servicio_regular = (servicio - 1.5) / (2.5 - 1.5);
elseif ((servicio  >= 2.5 ) && (servicio <=4.5))
    servicio_regular = 1;
elseif ((servicio  >= 4.5) && (servicio <= 5.5))
    servicio_regular = (5.5 - servicio) / (5.5 - 4.5);
end


if((servicio >= 4) && (servicio <= 5.5))
    servicio_bueno = (servicio - 4.5) / (5.5 - 4);
elseif ((servicio >= 5.5) && (servicio <= 7.5))
    servicio_bueno = 1;
elseif ((servicio >= 7.5) && (servicio <= 9))
    servicio_bueno = (9 - servicio) / (9 - 7.5);
end

if((servicio >= 7.5) && (servicio <= 8.5))
    servicio_excelente = (servicio - 7.5) / (8.5 - 7.5);
elseif ((servicio >= 8.5) && (servicio <=10))
    servicio_excelente = 1;
end

%---------------------------COMIDA-------------------------------------
if(comida < 0 )
    comida_mala = 0;
elseif((comida >= 0) && (comida <= 15))
    comida_mala = 1;
elseif((comida >= 15) && (comida <= 30))
    comida_mala = (30 - comida ) / (30 - 15);
end

if((comida >= 15) && (comida <= 25))
    comida_normal= (comida - 15) / (25 - 15);
elseif ((comida >= 25 ) && (comida <= 45))
    comida_normal = 1;
elseif ((comida >= 45) && (comida <= 55))
    comida_normal = (55 - comida) / (55 - 45);
end

if((comida >= 45) && (comida <= 55))
    comida_buena = (comida - 45) / (55 - 45);
elseif ((comida >= 55) && (comida <= 75))
    comida_buena = 1;
elseif ((comida >= 75) && (comida <=85))
    comida_buena = (85 - comida) / (85 -75);
end

if((comida >= 75) && (comida <= 85))
    comida_excelente = (comida - 75) / (85 - 75);
elseif ( (comida >= 85) && (comida <= 100))
    comida_excelente = 1;
end

z = 0:0.1:20;

baja = trapmf(z, [0 0 4 7]);
normal = trapmf(z, [4 7 11 14]);
alta = trapmf(z, [11 14 20 20]);

reglas = [min(servicio_malo, comida_mala);      
          min(servicio_malo, comida_normal);     
          min(servicio_malo, comida_buena);      
          min(servicio_malo, comida_excelente);  
          min(servicio_regular, comida_mala);     
          min(servicio_regular, comida_normal);  
          min(servicio_regular, comida_buena);   
          min(servicio_regular, comida_excelente);
          min(servicio_bueno, comida_mala);       
          min(servicio_bueno, comida_normal);     
          min(servicio_bueno, comida_buena);      
          min(servicio_bueno, comida_excelente);  
          min(servicio_excelente, comida_mala);   
          min(servicio_excelente, comida_normal); 
          min(servicio_excelente, comida_buena); 
          min(servicio_excelente, comida_excelente)];

propina_mf = max([reglas(1) * baja;               
                 reglas(2) * baja;                
                 reglas(3) * normal;              
                 reglas(4) * normal;              
                 reglas(5) * baja;                
                 reglas(6) * normal;              
                 reglas(7) * normal;              
                 reglas(8) * normal;              
                 reglas(9) * normal;              
                 reglas(10) * normal;             
                 reglas(11) * alta;               
                 reglas(12) * alta;               
                 reglas(13) * normal;           
                 reglas(14) * normal;     
                 reglas(15) * alta;          
                 reglas(16) * alta]);

if sum(propina_mf) == 0
    propina = 0;
else
    propina = sum(z .* propina_mf) / sum(propina_mf);
end

disp('Propina: ')
disp(propina)

