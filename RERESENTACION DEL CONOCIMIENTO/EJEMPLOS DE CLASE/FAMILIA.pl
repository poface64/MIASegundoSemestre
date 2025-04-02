
% Defino las relaciones
%progenitor(benjamin,antonio).
%progenitor(maria,antonio).
%progenitor(samuel,benjamin).
%progenitor(alicia,benjamin).
%hombre(benjamin).
%hombre(samuel).

% Reglas
%padre(X,Y):- 
%    progenitor(X,Y),
%    hombre(X),!.

%%% Ejemplo del orgulloso %%

% Relaciones %
progenitor(juan,maria).
progenitor(juan,cristina).
hombre(juan).
recien_nacido(cristina).

% Reglas
padre(X,Y) :- progenitor(X,Y),hombre(X).
orgulloso(X):- padre(X,Y),recien_nacido(Y).


    