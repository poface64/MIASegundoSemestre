% Declaración de dinámicos
:- dynamic casoSospechoso/1.
:- dynamic casoConfirmado/1.

% --------------------------
% Personal de salud
% --------------------------

%% Tipo %%
personal_salud(X) :- enfermera(X).
personal_salud(X) :- epidemiologo(X).

%% Subtipo %%
enfermera(enfermera1).
epidemiologo(epidemio1).


% --------------------------
% Personas
% --------------------------

persona(juan).
persona(maria).
persona(pedro).


% --------------------------
% Sintomatología
% --------------------------

presenta_sintoma(juan, fiebre).
presenta_sintoma(juan, tos).
presenta_sintoma(juan, dificultad_respiratoria).
tiene_enfermedad_respiratoria(juan).

% --------------------------
% Viajes y contactos
% --------------------------

% Viajes
viajo_a(juan, china).

% Contacto
contacto_directo(juan, maria).

contacto_con(A, B) :-
    contacto_directo(A, B);
    contacto_directo(B, A).

% --------------------------
% Resultado laboratorio
% --------------------------

resultado_laboratorio(juan, positivo).

% --------------------------
% Uso de mascarilla
% --------------------------

usa_mascarilla(juan).

% --------------------------
% Niveles de atención
% --------------------------

nivel_atencion(juan, primer_nivel).
nivel_atencion(maria, tercer_nivel).

% --------------------------
% Países de riesgo
% --------------------------

pais_riesgo(china).
pais_riesgo(italia).
pais_riesgo(iran).
pais_riesgo(japon).
pais_riesgo(hong_kong).
pais_riesgo(corea_del_sur).
pais_riesgo(singapur).

% --------------------------
% Precauciones estándar
% --------------------------

precaucion_estandar(higiene_de_manos).
precaucion_estandar(uso_de_guantes).
precaucion_estandar(bata_impermeable).
precaucion_estandar(uso_mascarilla).
precaucion_estandar(uso_contenedores).

% --------------------------
% Precauciones por gotas
% --------------------------

precaucion_gotas(uso_equipo_desechable).
precaucion_gotas(mascarilla_quirurgica).
precaucion_gotas(distancia_metro).

% --------------------------
% Precauciones por aerosoles
% --------------------------

precaucion_aerosoles(respirador_n95).

% --------------------------
% Aplicación de precauciones por personal
% --------------------------

aplica(enfermera1, higiene_de_manos).
aplica(enfermera1, uso_de_guantes).
aplica(enfermera1, bata_impermeable).
aplica(enfermera1, proteccion_facial).
aplica(enfermera1, mascarilla_quirurgica).
aplica(enfermera1, respirador_n95).

% Verificar precaucion aplicada
precaucion_aplicada_a(Precaucion, Personal) :-
    aplica(Personal, Precaucion).

% --------------------------
% Toma de muestras
% --------------------------

tipo_muestra(exudado_nasofaringeo).
tipo_muestra(exudado_faringeo).
tipo_muestra(lavado_bronquioalveolar).
tipo_muestra(biopsia_pulmonar).

toma_muestra(enfermera1, juan, exudado_nasofaringeo).
toma_muestra(enfermera1, juan, exudado_faringeo).


% --------------------------
% Aislamiento aplicado
% --------------------------

aislamiento_recomendado(juan, hospitalario_individual).
aislamiento_recomendado(maria, domicilio).


% --------------------------
% Definición de caso sospechoso
% --------------------------

% un confirmado ya no debe registrarse como sospechoso
esCasoSospechoso(Persona) :-
    casoConfirmado(Persona),
    format("Error: ~w ya es un caso confirmado, no puede registrarse como sospechoso.~n", [Persona]), !, fail.

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

% Si no cumple definición
esCasoSospechoso(Persona) :-
    write(Persona), write(" no cumple definición de caso sospechoso."), nl,
    fail.

% --------------------------
% Definición de caso confirmado
% --------------------------

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

%% precauciones %%

% Verificador general para cualquier categoría de precauciones

cumple_todas(Personal, Categoria, PrecaucionList) :-
    forall(member(Precaucion, PrecaucionList),
           aplica(Personal, Precaucion)).

% Definición para cada tipo de precaución

cumple_precauciones_estandar(Personal) :-
    findall(Prec, precaucion_estandar(Prec), Lista),
    ( cumple_todas(Personal, estandar, Lista)
      -> write(Personal), write(" cumple todas las precauciones estándar."), nl
      ;  write(Personal), write(" NO cumple todas las precauciones estándar."), nl,
         mostrar_faltantes(Personal, estandar)
    ).

cumple_precauciones_gotas(Personal) :-
    findall(Prec, precaucion_gotas(Prec), Lista),
    ( cumple_todas(Personal, gotas, Lista)
      -> write(Personal), write(" cumple todas las precauciones por gotas."), nl
      ;  write(Personal), write(" NO cumple todas las precauciones por gotas."), nl,
         mostrar_faltantes(Personal, gotas)
    ).

cumple_precauciones_aerosoles(Personal) :-
    findall(Prec, precaucion_aerosoles(Prec), Lista),
    ( cumple_todas(Personal, aerosoles, Lista)
      -> write(Personal), write(" cumple todas las precauciones por aerosoles."), nl
      ;  write(Personal), write(" NO cumple todas las precauciones por aerosoles."), nl,
         mostrar_faltantes(Personal, aerosoles)
    ).

% Mostrar faltantes

mostrar_faltantes(Personal, Categoria) :-
    obtener_precauciones(Categoria, Lista),
    findall(Prec, (member(Prec, Lista), \+ aplica(Personal, Prec)), Faltantes),
    write("Faltan las siguientes medidas: "), write(Faltantes), nl.

% Obtener lista según categoría

obtener_precauciones(estandar, Lista) :-
    findall(Prec, precaucion_estandar(Prec), Lista).

obtener_precauciones(gotas, Lista) :-
    findall(Prec, precaucion_gotas(Prec), Lista).

obtener_precauciones(aerosoles, Lista) :-
    findall(Prec, precaucion_aerosoles(Prec), Lista).

%% Aislamiento inferido %%

aislamiento_inferido(Persona, Tipo) :-
    casoConfirmado(Persona),
    nivel_atencion(Persona, tercer_nivel),
    Tipo = hospitalario_individual,
    format("~w requiere aislamiento hospitalario individual por ser caso confirmado en tercer nivel de atención.~n", [Persona]), !.

aislamiento_inferido(Persona, Tipo) :-
    casoSospechoso(Persona),
    nivel_atencion(Persona, primer_nivel),
    Tipo = domicilio,
    format("~w debe permanecer en aislamiento domiciliario por ser caso sospechoso sin necesidad de hospitalización.~n", [Persona]), !.

aislamiento_inferido(Persona, sin_dato) :-
    format("No se pudo inferir el tipo de aislamiento para ~w. Verifique el estado del caso y su nivel de atención.~n", [Persona]), fail.

%% Notificar el caso %%

notificar_UIES(Persona) :-
    casoSospechoso(Persona),
    format("Notificando de inmediato a UIES y jurisdicción sanitaria sobre ~w...~n", [Persona]),
    write("Correo: ncov@dgepi.salud.gob.mx"), nl,
    write("Teléfonos: 5337-1845 / 800-00-44-800"), nl,
    write("Formato: SUIVE-1 con Epiclave No. 191"), nl, !.

notificar_UIES(Persona) :-
    write("No se puede notificar porque "), write(Persona), write(" no es un caso sospechoso registrado."), nl, fail.

%% realizar seguimiento %%

realizar_seguimiento(Persona) :-
    casoConfirmado(Persona),
    contacto_con(Otro, Persona),
    format("~w tuvo contacto con el caso confirmado ~w.~n", [Otro, Persona]),
    write("Se debe iniciar monitoreo diario y estudio epidemiológico a la persona en contacto."), nl, !.

realizar_seguimiento(Persona) :-
    \+ casoConfirmado(Persona),
    format("~w no es un caso confirmado, no se inicia seguimiento de contactos.~n", [Persona]), fail.

realizar_seguimiento(Persona) :-
    casoConfirmado(Persona),
    \+ contacto_con(_, Persona),
    format("No se registraron contactos directos con ~w para seguimiento.~n", [Persona]), !.

%% Muestra tomada %%

muestra_valida(Persona) :-
    toma_muestra(_, Persona, exudado_nasofaringeo),
    toma_muestra(_, Persona, exudado_faringeo),
    format("La muestra de ~w incluye exudado nasofaríngeo y faríngeo: muestra válida para diagnóstico COVID-19.~n", [Persona]), !.

muestra_valida(Persona) :-
    format("La muestra de ~w NO cumple con los requisitos estándar de diagnóstico (faltan ambos exudados).~n", [Persona]), fail.

% Clasificación exhaustiva
persona_clasificada(X) :-
    (casoSospechoso(X); casoConfirmado(X)),
    format("~w está clasificado en el sistema (sospechoso o confirmado).~n", [X]), !.
    
persona_clasificada(X) :-
    format("Alerta: ~w no está clasificado como sospechoso ni confirmado.~n", [X]),
    fail.
