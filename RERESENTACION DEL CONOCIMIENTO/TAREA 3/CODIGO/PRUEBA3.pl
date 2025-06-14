% --------------------------
% Declaración de dinámicos
% --------------------------
:- dynamic casoSospechoso/1, casoConfirmado/1.

% --------------------------
% Personal de salud
% --------------------------
personal_salud(enfermera1, enfermera).
personal_salud(epidemio1, epidemiologo).

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

% Enfermedad respiratoria: inferida por síntomas frecuentes
tiene_enfermedad_respiratoria(Persona) :-
    presenta_sintoma(Persona, fiebre),
    presenta_sintoma(Persona, tos).

% --------------------------
% Viajes y contactos
% --------------------------
viajo_a(juan, china).
contacto_con(juan, maria).

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
% Aislamiento recomendado manual
% --------------------------
aislamiento_recomendado(juan, hospitalario_individual).
aislamiento_recomendado(maria, domicilio).

% --------------------------
% Reglas: Caso Sospechoso
% --------------------------
esCasoSospechoso(Persona) :-
    casoSospechoso(Persona),
    write(Persona), write(" ya está registrado como caso sospechoso."), nl, !.

% Variante 1: por viaje a país de riesgo
esCasoSospechoso(Persona) :-
    tiene_enfermedad_respiratoria(Persona),
    viajo_a(Persona, Pais),
    pais_riesgo(Pais),
    \+ casoSospechoso(Persona),
    format("~w cumple los criterios de caso sospechoso por viaje a país de riesgo: ~w.~n", [Persona, Pais]),
    asserta(casoSospechoso(Persona)), !.

% Variante 2: por contacto con caso confirmado
esCasoSospechoso(Persona) :-
    tiene_enfermedad_respiratoria(Persona),
    contacto_con(Persona, Otro),
    (esCasoConfirmado(Otro); resultado_laboratorio(Otro, positivo)),
    \+ casoSospechoso(Persona),
    format("~w cumple los criterios de caso sospechoso por contacto con caso confirmado: ~w.~n", [Persona, Otro]),
    asserta(casoSospechoso(Persona)), !.

% Si no cumple definición
esCasoSospechoso(Persona) :-
    write(Persona), write(" no cumple definición de caso sospechoso."), nl,
    fail.

% --------------------------
% Reglas: Caso Confirmado
% --------------------------
esCasoConfirmado(Persona) :-
    casoConfirmado(Persona),
    write(Persona), write(" ya está registrado como caso confirmado."), nl, !.

esCasoConfirmado(Persona) :-
    esCasoSospechoso(Persona),
    resultado_laboratorio(Persona, positivo),
    \+ casoConfirmado(Persona),
    format("~w es un caso confirmado por resultado positivo en laboratorio.~n", [Persona]),
    asserta(casoConfirmado(Persona)), !.

esCasoConfirmado(Persona) :-
    write(Persona), write(" no cumple definición de caso confirmado."), nl,
    fail.

% --------------------------
% Verificador de precauciones
% --------------------------
cumple_todas(Personal, Lista) :-
    forall(member(Precaucion, Lista),
           aplica(Personal, Precaucion)).

cumple_precauciones_estandar(Personal) :-
    findall(Prec, precaucion_estandar(Prec), Lista),
    ( cumple_todas(Personal, Lista)
      -> format("~w cumple todas las precauciones estándar.~n", [Personal])
      ;  format("~w NO cumple todas las precauciones estándar.~n", [Personal]),
         mostrar_faltantes(Personal, Lista)
    ).

cumple_precauciones_gotas(Personal) :-
    findall(Prec, precaucion_gotas(Prec), Lista),
    ( cumple_todas(Personal, Lista)
      -> format("~w cumple todas las precauciones por gotas.~n", [Personal])
      ;  format("~w NO cumple todas las precauciones por gotas.~n", [Personal]),
         mostrar_faltantes(Personal, Lista)
    ).

cumple_precauciones_aerosoles(Personal) :-
    findall(Prec, precaucion_aerosoles(Prec), Lista),
    ( cumple_todas(Personal, Lista)
      -> format("~w cumple todas las precauciones por aerosoles.~n", [Personal])
      ;  format("~w NO cumple todas las precauciones por aerosoles.~n", [Personal]),
         mostrar_faltantes(Personal, Lista)
    ).

mostrar_faltantes(Personal, Lista) :-
    findall(Prec, (member(Prec, Lista), \+ aplica(Personal, Prec)), Faltantes),
    write("Faltan las siguientes medidas: "), write(Faltantes), nl.

% --------------------------
% Aislamiento Inferido
% --------------------------
aislamiento_inferido(Persona, hospitalario_individual) :-
    casoConfirmado(Persona),
    nivel_atencion(Persona, tercer_nivel).

aislamiento_inferido(Persona, domicilio) :-
    casoSospechoso(Persona),
    nivel_atencion(Persona, primer_nivel).

% --------------------------
% Notificación Simulada
% --------------------------
notificar_UIES(Persona) :-
    casoSospechoso(Persona),
    format("Se notifica de inmediato a UIES y jurisdicción sobre ~w.~n", [Persona]).

% --------------------------
% Seguimiento de contactos
% --------------------------
realizar_seguimiento(Persona) :-
    casoConfirmado(Persona),
    contacto_con(Otro, Persona),
    format("Se debe hacer seguimiento a ~w por contacto con ~w.~n", [Otro, Persona]).

% --------------------------
% Verificar muestra correcta
% --------------------------
muestra_valida(Persona) :-
    toma_muestra(_, Persona, exudado_nasofaringeo),
    toma_muestra(_, Persona, exudado_faringeo),
    write("La muestra de "), write(Persona), write(" es válida."), nl.
