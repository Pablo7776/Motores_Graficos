extends Node2D
class_name Hud
var pj_actual

func _ready() -> void:
	$Timer.start(30)

func _on_gestor_cambiar_turno(pj, turno_actual):
	$Timer.start(30)
	pj_actual = pj
	_mostrar_turno()

func _process(delta: float) -> void:
	$Tiempo.set_text(str("Segundos:", int($Timer.get_time_left())))

func _mostrar_turno():
	$PJs_de_Jugador_1.set_text("Jugador: " + str(pj_actual.jugador_id+1) + " Personaje: " + str(pj_actual.indice_en_equipo+1))
