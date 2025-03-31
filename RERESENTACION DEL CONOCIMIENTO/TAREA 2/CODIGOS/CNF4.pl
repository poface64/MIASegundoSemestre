
%%%% Declaración de los operadores %%%%
:- op(500, xfy, v).  % 'v' para disyunción
:- op(600, xfy, ^).  % '^' para conjunción
:- op(500, fy, ~). % 'neg' para negación
:- op(610, xfy, ->). % -> para la implicación

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
implfree(A -> B, ~FA v FB):-
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

