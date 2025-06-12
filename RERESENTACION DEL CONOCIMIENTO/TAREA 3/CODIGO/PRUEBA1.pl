% Declaración de bases dinámicas para permitir asserta/1
:- dynamic casoSospechoso/1.
:- dynamic casoConfirmado/1.

% Personas
persona(juan).
persona(maria).

% Sintomatología
presenta_sintoma(juan, fiebre).
presenta_sintoma(juan, tos).
presenta_sintoma(juan, dificultad_respiratoria).

% Enfermedad respiratoria
tiene_enfermedad_respiratoria(juan).

% Antecedentes de viaje
viajo_a(juan, italia).

% Contactos
contacto_con(juan, maria).

% Resultado laboratorio
resultado_laboratorio(juan, positivo).

% Uso de mascarilla (si/no)
usa_mascarilla(juan, si).
usa_mascarilla(maria, no).

% Niveles de atención (persona, nivel)
nivel_atencion(juan, primer_nivel).
nivel_atencion(maria, tercer_nivel).

% Países de riesgo
pais_riesgo(china).
pais_riesgo(italia).
pais_riesgo(iran).
pais_riesgo(japon).
pais_riesgo(hong_kong).
pais_riesgo(corea_del_sur).
pais_riesgo(singapur).

% -------------------------------------------
% Definición de caso sospechoso con explicaciones
% -------------------------------------------

esCasoSospechoso(Persona) :-
    casoSospechoso(Persona), 
    write(Persona), write(" ya está registrado como caso sospechoso."), nl, !.

% Variante 1: por viaje a país de riesgo
esCasoSospechoso(Persona) :-
    tiene_enfermedad_respiratoria(Persona),
    viajo_a(Persona, Pais),
    pais_riesgo(Pais),
    format("~w cumple los criterios de caso sospechoso por viaje reciente a país de riesgo: ~w.~n", [Persona, Pais]),
    asserta(casoSospechoso(Persona)), !.

% Variante 2: por contacto con caso confirmado
esCasoSospechoso(Persona) :-
    tiene_enfermedad_respiratoria(Persona),
    contacto_con(Persona, Otro),
    esCasoConfirmado(Otro),
    format("~w cumple los criterios de caso sospechoso por contacto reciente con caso confirmado: ~w.~n", [Persona, Otro]),
    asserta(casoSospechoso(Persona)), !.

esCasoSospechoso(Persona) :-
    write(Persona), write(" no cumple definición de caso sospechoso."), nl,
    fail.

% -------------------------------------------
% Definición de caso confirmado con explicación

esCasoConfirmado(Persona) :-
    casoConfirmado(Persona), 
    write(Persona), write(" ya está registrado como caso confirmado."), nl, !.

esCasoConfirmado(Persona) :-
    esCasoSospechoso(Persona),
    resultado_laboratorio(Persona, positivo),
    format("~w es un caso confirmado porque su prueba de laboratorio resultó positiva.~n", [Persona]),
    asserta(casoConfirmado(Persona)), !.

esCasoConfirmado(Persona) :-
    write(Persona), write(" no cumple definición de caso confirmado."), nl,
    fail.