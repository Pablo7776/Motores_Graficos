extends Control

@onready var label_ganador: Label = $Panel/Label

func _ready() -> void:
	label_ganador.text = "¡JUGADOR %d GANÓ LA PARTIDA!" % (DatosPartida.jugador_ganador)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")
