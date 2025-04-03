%% Declaración de los operadores %%
:- op(700, xfy, ⇒). % ⇒ para la implicación
:- op(500, xfy, ^).  % '^' para conjunción
:- op(600, xfy, v).  % 'v' para disyunción
:- op(400, fy, ~).   % 'neg' para negación

%% Semantica %%
v(X,Y):- X;Y.
^(X,Y):- X,Y.
~(X):- \+ X.
⇒(X,Y):- (\X;Y).


% Predicado para verificar si una expresión es un literal
es_literal(X) :- atom(X).
es_literal(~X) :- atom(X). 

% Verificar primer la eliminación de la implicación

%ϕ = (¬p ∧ q =⇒ p ∧ (r =⇒ q))

%IMPL FREE (φ) = 
%- ¬IMPL FREE (¬p ∧ q) ∨ IMPL FREE (p ∧ (r → q))
% Separa en 2 partes, lo que esta antes de la implicación
% y lo que esta despues de la implicación.
% Niega la primera parte y aplica de formaa recursiva la IMPL FREE 
% Junta con un v la otra parte como IMPLFREE del resto.

% Caso base, si la cosa ya es una literal, devuelve la literal %
implfree(Literal, Literal):- atom(Literal).
implfree(~X, ~FX):- implfree(X,FX). % Caso para la negación

% Caso 1 implicación: A -> B se convierte en ~A v B
implfree(A ⇒ B, ~FA v FB):-
    implfree(A, FA),
    implfree(B, FB).

% Caso 2:  para la conjunción
implfree(A ^ B, FA ^ FB) :-
    implfree(A, FA),
    implfree(B, FB).

% Caso 3: para la disyunción
implfree(A v B, FA v FB) :-
    implfree(A, FA),
    implfree(B, FB).


%%% SIGUE NNF %%%
%Acorde con el flujo de trabajo, el siguiente paso es NNF %

%%%% NNF %%%%
% Procesar los casos no tan agradables con negaciones %
% Caso BASE: Si FI es una literal, devuelve esa literal
nnf(X, X) :- atom(X).  % Lo devuelve tal cual.
nnf(~X, ~X) :- atom(X).  % Lo devuelve tal cual.

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

%%%% CNF %%%%
% Caso base: Si es una literal, ya está en CNF
cnf(X, X) :- atom(X).
cnf(~X, ~X) :- atom(X).

% Caso 1: (FI1 ^ FI2) se convierte en (cnf(FI1) ^ cnf(FI2))
cnf(X ^ Y, C) :- 
    cnf(X, CX),
    cnf(Y, CY),
    C = CX ^ CY.

% Caso 2: (FI1 v FI2) se convierte en una disyunción de las conjunciones:
% Distribuir la disyunción sobre la conjunción: (A v (B ^ C)) -> (A v B) ^ (A v C)
cnf(X v Y, C) :- 
    cnf(X, CX),
    cnf(Y, CY),
    distribuye(CX, CY, C).

% Caso 3: (FI1 v ~FI2) se convierte en una disyunción de las conjunciones:
% Distribuir la disyunción sobre la conjunción
cnf(~(X v Y), C) :- 
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

