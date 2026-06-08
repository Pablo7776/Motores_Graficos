extends Node2D
class_name ContadorDeVida

@onready var personaje= get_parent()
@onready var health_manager = get_parent().get_node("HealthManager")
@onready var marcador = preload("res://Escenas/Personajes/marcador_de_vida.tscn")


func actualizar_barra():
	var vida_actual = health_manager.get_health()
	var radio=25
	
	
	if vida_actual == 0:
		return
	
	else:
		for marcadores in get_children():
			marcadores.queue_free()
		var angulo = (PI)/vida_actual
		for i in range(vida_actual):
			var marcador_actual=marcador.instantiate()
			var posicion= -PI + i*angulo
			marcador_actual.position = Vector2(cos(posicion), sin(posicion)) * radio
			add_child(marcador_actual)
