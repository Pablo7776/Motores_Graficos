extends Node2D


signal iniciar 

func _ready() -> void:
	iniciar.emit(DatosPartida.jugadores, DatosPartida.personajes)  #✨Armado en Clase
