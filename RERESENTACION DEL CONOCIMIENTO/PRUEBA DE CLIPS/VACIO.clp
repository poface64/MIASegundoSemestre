; Definición de plantillas
(deftemplate paciente
   (slot nombre (type STRING))
   (slot edad (type INTEGER))
   (multislot sintomas)
   (slot temperatura (type FLOAT) (default 36.5))
   (slot diagnostico (type STRING) (default "pendiente"))
)

(deftemplate enfermedad
   (slot nombre (type STRING))
   (multislot sintomas-requeridos)
   (slot temperatura-minima (type FLOAT) (default 0.0))
   (slot temperatura-maxima (type FLOAT) (default 100.0))
)

; Hechos iniciales
(deffacts base-conocimiento
   ; Catálogo de enfermedades
   (enfermedad (nombre "Gripe") 
               (sintomas-requeridos fiebre dolor-cabeza dolor-muscular)
               (temperatura-minima 38.0))
               
   (enfermedad (nombre "Resfriado común") 
               (sintomas-requeridos congestion estornudos)
               (temperatura-minima 37.0) 
               (temperatura-maxima 38.0))
               
   (enfermedad (nombre "Alergia estacional") 
               (sintomas-requeridos congestion estornudos picor-ojos)
               (temperatura-maxima 37.0))
)

; Reglas del sistema experto
(defrule registrar-paciente
   "Solicita datos del paciente"
   (not (paciente (nombre ?)))
   =>
   (printout t "Nombre del paciente: ")
   (bind ?nombre (read))
   (printout t "Edad: ")
   (bind ?edad (read))
   (printout t "Temperatura: ")
   (bind ?temp (read))
   (printout t "Síntomas (separados por espacios): ")
   (bind ?sint (explode$ (readline)))
   
   (assert (paciente (nombre ?nombre) 
                    (edad ?edad) 
                    (temperatura ?temp) 
                    (sintomas ?sint)))
)

(defrule diagnosticar-enfermedad
   "Diagnostica basándose en síntomas y temperatura"
   ?p <- (paciente (nombre ?nombre) 
                  (sintomas $?sintomas-paciente) 
                  (temperatura ?temp) 
                  (diagnostico "pendiente"))
   
   (enfermedad (nombre ?enf) 
               (sintomas-requeridos $?sintomas-req&:(subsetp ?sintomas-req ?sintomas-paciente))
               (temperatura-minima ?t-min&:(<= ?t-min ?temp))
               (temperatura-maxima ?t-max&:(>= ?t-max ?temp)))
   =>
   (modify ?p (diagnostico ?enf))
   (printout t "Diagnóstico para " ?nombre ": " ?enf crlf)
)

(defrule sin-diagnostico
   "Se activa cuando no hay diagnóstico claro"
   ?p <- (paciente (nombre ?nombre) (diagnostico "pendiente"))
   (not (diagnosticar-enfermedad))
   =>
   (modify ?p (diagnostico "Indeterminado"))
   (printout t "No se pudo determinar un diagnóstico claro para " ?nombre crlf)
   (printout t "Se recomienda hacer más pruebas." crlf)
)

(defrule recomendar-tratamiento
   "Recomienda tratamiento según diagnóstico"
   (paciente (nombre ?nombre) (diagnostico "Gripe"))
   =>
   (printout t "Tratamiento para " ?nombre ":" crlf)
   (printout t "- Reposo en cama" crlf)
   (printout t "- Paracetamol cada 8 horas" crlf)
   (printout t "- Líquidos abundantes" crlf)
)