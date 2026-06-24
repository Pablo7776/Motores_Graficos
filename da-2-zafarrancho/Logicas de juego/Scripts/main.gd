extends Node2D


signal iniciar 

func _ready() -> void:
	iniciar.emit(DatosPartida.cantidad_jugadores, DatosPartida.personajes_por_jugador, DatosPartida.personajes_seleccionados)  #✨Armado en Clase


func _on_gestor_de_turnos_v_2_victoria(ganador: Variant) -> void:
	$Camera2D.zoom = Vector2(0.5,0.5)
	DatosPartida.jugador_ganador = ganador
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Interfaz/Escenas/victoria.tscn")
