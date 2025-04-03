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

%%% DISTRB %%%
% Caso base: Si ninguno de los dos es una conjunción, simplemente devolvemos A v B
distribuye(A, B, A v B).

% Distribuye A v (B ^ C) -> (A v B) ^ (A v C)
% Caso 1: Si n1 es una conjunción (n1 = n11 ^ n12), entonces distribuimos sobre n2
distribuye(A ^ B, C, R) :-
    distribuye(A, C, AC),
    distribuye(B, C, BC),
    R = AC ^ BC.

% Caso 2: Si n2 es una conjunción (n2 = n21 ^ n22), distribuimos sobre n1
distribuye(A, B ^ C, R) :-
    distribuye(A, B, AB),
    distribuye(A, C, AC),
    R = AB ^ AC.


%% Query del inciso 2

%FORMULA =(~p^q⇒ p^(r⇒q)),implfree(FORMULA,Q),nnf(Q,P),cnf(P,R).
%FORMULA =  (~p^q⇒p^(r⇒q)),
%Q = ~ (~p^q)v p^(~r v q),
%P = R, R =  (p v ~q)v p^(~r v q) .

%% Query del inciso 3

%FORMULA = (a^b^c^d^e^(h ⇒ (f v g))^i^j^k),implfree(FORMULA,Q),nnf(Q,P),cnf(P,R).
%FORMULA = a^b^c^d^e^(h⇒f v g)^i^j^k,
%Q = P, P = R, R = a^b^c^d^e^(~h v f v g)^i^j^k 



