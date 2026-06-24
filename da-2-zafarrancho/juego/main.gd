extends Node2D


signal iniciar 

func _ready() -> void:
	iniciar.emit(DatosPartida.cantidad_jugadores, DatosPartida.personajes_por_jugador, DatosPartida.personajes_seleccionados)  #✨Armado en Clase
