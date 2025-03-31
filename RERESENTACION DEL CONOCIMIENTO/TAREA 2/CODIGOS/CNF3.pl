
%%%% Declaración de los operadores %%%%
:- op(500, xfy, v).  % 'v' para disyunción
:- op(600, xfy, ^).  % '^' para conjunción
:- op(500, fy, ~). % 'neg' para negación
:- op(610, xfy, ->). % -> para la implicación

% Predicado para verificar si una expresión es un literal
es_literal(X) :- atom(X).
es_literal(neg(X)) :- atom(X). 

%%%% CNF %%%%

% Caso base %
% cuando una literal es solo una literal, entonces ya es CNF
% y la salida es la misma literal

cnf(Literal, Literal):- atom(Literal).
 
% Caso 1, cuando se tiene una disyunción de 2 literales fi1 Y fi2.
% Se llama a CNF recursivamente sobre los fii para obtener n1 y n2. CNF es n1 y n2

cnf(A ^ B, CNF_A ^ CNF_B) :-
    cnf(A, CNF_A),
    cnf(B, CNF_B).

% Caso 2 si FI tiene la forma fi1 v fi2, se llama a CNF sobre cada fii
% pero no devuelve n1 y n2 puesto que esta solo es una forma normal 
% si se cumple que ni son literales
% Caso para disyunción

cnf(A v B, CNF) :-
    cnf(A, CNF_A),
    cnf(B, CNF_B),
    distrib(CNF_A, CNF_B, CNF).

% Caso 3 Se debe distribuir la disyunción sobre la conjunción,
% garantizando que las disyunciones generadas sean de literales
% para esto se implementa dicho con caso con distr(n1, n2).

%%%% Implementación de la DISTR %%%%

% Caso BASE
% Si n1 = n11 Y n12 (ambas literales) 
% Devuelve n1 O n2

distrib(A, B, A v B) :-
    es_literal(A),
    es_literal(B).

% Caso 1: n1 = n11 Y n12 (n11 y n12 literales)
% Distribuye(n11,n2) Y distribuye (n12,n2)
distrib(A ^ B, C, CNF_A ^ CNF_B) :-
    distrib(A, C, CNF_A),
    distrib(B, C, CNF_B).
    
% Caso 2: n2 = n21 Y n22 (n21 y n22 literales)
% Distribuye(n1,n21) Y distribuye(n1,n22)
distrib(A, B ^ C, CNF_B ^ CNF_C) :-
    distrib(A, B, CNF_B),
    distrib(A, C, CNF_C).

%%%% NNF %%%%
% Procesar los casos no tan agradables con negaciones %
% Caso BASE: Si FI es una literal, devuelve esa literal
nnf(X, X) :- atom(X).  % Lo devuelve tal cual.

% Caso 1: Si ~~fi1, devuelve fi1
nnf(~ ~X, NNF) :- nnf(X, NNF).  % ~~fi1 => fi1

% Caso 2: FI1 Y FI2 regresa nnf(FI1) Y nnf(FI2)
nnf(X ^ Y, NNF) :- 
    nnf(X, NNF_X),
    nnf(Y, NNF_Y),
    NNF = NNF_X ^ NNF_Y.

% Caso 3: FI1 O FI2 regresa nnf(FI1) O nnf(FI2)
nnf(X v Y, NNF) :- 
    nnf(X, NNF_X),
    nnf(Y, NNF_Y),
    NNF = NNF_X v NNF_Y.

% Caso 4: ~(FI1 Y FI2) regresa nnf(~FI1) O nnf(~FI2)
nnf(~(X ^ Y), NNF) :- 
    nnf(~X, NNF_X),
    nnf(~Y, NNF_Y),
    NNF = NNF_X v NNF_Y.

% Caso 5: ~(FI1 O FI2) regresa nnf(~FI1) Y nnf(~FI2)
nnf(~(X v Y), NNF) :- 
    nnf(~X, NNF_X),
    nnf(~Y, NNF_Y),
    NNF = NNF_X ^ NNF_Y.


