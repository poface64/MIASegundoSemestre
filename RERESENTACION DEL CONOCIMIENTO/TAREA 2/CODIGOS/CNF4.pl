%% Declaración de los operadores %%
:- op(700, xfy, ⇒). % ⇒ para la implicación
:- op(500, xfy, ^).  % '^' para conjunción
:- op(600, xfy, v).  % 'v' para disyunción
:- op(400, fy, ~).   % 'neg' para negación

%% Semantica %%
v(X,Y):- X;Y.              % Disyunción
^(X,Y):- X,Y.              % Conjunción
~(X):- \+ X.               % Negación
⇒(X,Y):- (\X;Y).          % Implicación

% Predicado para verificar si una expresión es un literal
es_literal(X) :- atom(X).
es_literal(~X) :- atom(X). 

% Eliminación de la implicación (IMPL FREE)
implfree(Literal, Literal):- atom(Literal).
implfree(~X, ~FX):- implfree(X,FX). % Caso para la negación
implfree(A ⇒ B, ~FA v FB):-         % A → B -> ¬A v B
    implfree(A, FA),
    implfree(B, FB).
implfree(A ^ B, FA ^ FB):-           % Conjunción
    implfree(A, FA),
    implfree(B, FB).
implfree(A v B, FA v FB):-           % Disyunción
    implfree(A, FA),
    implfree(B, FB).

%%% NNF %%%
% Transformación a forma normal negativa (NNF)
nnf(X, X) :- atom(X).  % Literal no necesita transformación
nnf(~X, ~X) :- atom(X).  % Negación de un literal
nnf(~ ~X, NNF) :- nnf(X, NNF).  % Eliminar doble negación
nnf(X ^ Y, NNF) :- 
    nnf(X, NNF_X),
    nnf(Y, NNF_Y),
    NNF = NNF_X ^ NNF_Y.  % Conjunción
nnf(X v Y, NNF) :- 
    nnf(X, NNF_X),
    nnf(Y, NNF_Y),
    NNF = NNF_X v NNF_Y.  % Disyunción
nnf(~(X ^ Y), NNF) :- 
    nnf(~X, NNF_X),
    nnf(~Y, NNF_Y),
    NNF = NNF_X v NNF_Y.  % De Morgan: ~(X ^ Y) -> ~X v ~Y
nnf(~(X v Y), NNF) :- 
    nnf(~X, NNF_X),
    nnf(~Y, NNF_Y),
    NNF = NNF_X ^ NNF_Y.  % De Morgan: ~(X v Y) -> ~X ^ ~Y

%%% CNF %%%
% Transformación a forma normal conjuntiva (CNF)
cnf(X, X) :- atom(X).  % Caso base: si es literal, ya está en CNF
cnf(~X, ~X) :- atom(X).  % Negación de un literal

% Caso 1: Conjunción de fórmulas
cnf(X ^ Y, C) :- 
    cnf(X, CX),
    cnf(Y, CY),
    C = CX ^ CY.

% Caso 2: Disyunción de fórmulas, distribución sobre la conjunción
cnf(X v Y, C) :- 
    cnf(X, CX),
    cnf(Y, CY),
    distribuye(CX, CY, C).

%%% Distribución según el pseudocódigo %%%
% Distribuye A v (B ^ C) -> (A v B) ^ (A v C)
% Caso 1: Si η1 es una conjunción (η1 = η11 ^ η12), entonces distribuimos sobre η2
distribuye(A ^ B, C, R) :-
    distribuye(A, C, AC),
    distribuye(B, C, BC),
    R = AC ^ BC.

% Caso 2: Si η2 es una conjunción (η2 = η21 ^ η22), distribuimos sobre η1
distribuye(A, B ^ C, R) :-
    distribuye(A, B, AB),
    distribuye(A, C, AC),
    R = AB ^ AC.

% Caso base: Si ninguno de los dos es una conjunción, simplemente devolvemos A v B
distribuye(A, B, A v B).

