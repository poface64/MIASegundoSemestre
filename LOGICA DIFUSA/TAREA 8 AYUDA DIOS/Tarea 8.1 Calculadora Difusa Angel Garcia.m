
%%% Entran 4 variables %%%%
% N1: Numero 1
% N2: Numero 2
% N3: Numero 3
% OP: Operador a aplicar

function salida = calculadoraD(n1,n2,n3,OP)
%%% Defino la función de membresia triangular %%%%  
function membership = triangular_mf(x,a,b,c)
  membership = max(0,min((x-a)/(b-a),(c-x)/(c-b))); % Ajuste del ancho
end
%Definir el caso base para fuzzificar los valores %
% Definir las funciones de membresia de las entradas para N1
N10 = triangular_mf(n1,0,0,1);
N11 = triangular_mf(n1,0,1,2);
N12 = triangular_mf(n1,1,2,3);
N13 = triangular_mf(n1,2,3,4);
N14 = triangular_mf(n1,3,4,5);
N15 = triangular_mf(n1,4,5,6);
N16 = triangular_mf(n1,5,6,7);
N17 = triangular_mf(n1,6,7,8);
N18 = triangular_mf(n1,7,8,9);
N19 = triangular_mf(n1,8,9,9);

% Definir las funciones de membresia de las entradas para N2
N20 = triangular_mf(n2,0,0,1);
N21 = triangular_mf(n2,0,1,2);
N22 = triangular_mf(n2,1,2,3);
N23 = triangular_mf(n2,2,3,4);
N24 = triangular_mf(n2,3,4,5);
N25 = triangular_mf(n2,4,5,6);
N26 = triangular_mf(n2,5,6,7);
N27 = triangular_mf(n2,6,7,8);
N28 = triangular_mf(n2,7,8,9);
N29 = triangular_mf(n2,8,9,9);

% Definir las funciones de membresia de las entradas para N2
N30 = triangular_mf(n3,0,0,1);
N31 = triangular_mf(n3,0,1,2);
N32 = triangular_mf(n3,1,2,3);
N33 = triangular_mf(n3,2,3,4);
N34 = triangular_mf(n3,3,4,5);
N35 = triangular_mf(n3,4,5,6);
N36 = triangular_mf(n3,5,6,7);
N37 = triangular_mf(n3,6,7,8);
N38 = triangular_mf(n3,7,8,9);
N39 = triangular_mf(n3,8,9,9);

% Preparo los conjuntos de salida para aplicar la pseudo defuzzificación %
C1 = [N10, N11, N12, N13, N14, N15, N16, N17, N18, N19];
C2 = [N20, N21, N22, N23, N24, N25, N26, N27, N28, N29];
C3 = [N30, N31, N32, N33, N34, N35, N36, N37, N38, N39];

% Definir los valores singletons %
Z = 0:9;
% Obtener los valores CRISP %
S1 = sum(C1.*Z);
S2 = sum(C2.*Z);
S3 = sum(C3.*Z);

% Tomar la decisión  de que operación hacer
if OP == "+"
    % Para el caso de la suma %%
    salida = sum([S1,S2,S3]);
    elseif OP == "-"
        % Hacer el caso de la resta  con 2 numeros%%
        salida = S1-S2;
    elseif OP == "*"
    % Hacer el caso de la multiplicación %%
        salida = S1*S2*S3;
    elseif OP == "/"
    % Hacer el caso de la división  con 2 numeros%%
        salida = S1/S2;
end
  
end

%% Corridas de ejemplo %%
calculadoraD(1.5,1,1,"+") % Suma de 3 numeros
calculadoraD(5.5,2.5,5,"-") % Resta de 2 numeros
calculadoraD(5,2,5,"/") % División de 2 de  numeros
calculadoraD(1,1.5,1.5,"*") % Multiplicación de 3 numeros


