extends Node2D

signal iniciar 

func _ready() -> void:
	iniciar.emit(2, 2)  #✨Armado en Clase
