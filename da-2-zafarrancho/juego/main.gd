extends Node2D


signal iniciar 

func _ready() -> void:
	iniciar.emit(2, 3)  #✨Armado en Clase
