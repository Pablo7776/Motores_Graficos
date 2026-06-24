extends Node2D
class_name ContadorDeVida

@onready var personaje= get_parent()
@onready var health_manager = get_parent().get_node("HealthManager")
@onready var marcador = preload("res://Personajes/Escenas/marcador_de_vida.tscn")
@onready var jugador:int
var semilla_color:float = 2

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
			jugador = personaje.jugador_id
			semilla_color = fmod(float(jugador) / 7.0, 1.0)
			marcador_actual.modulate = Color.from_hsv(semilla_color, 1.0, 1.0, 1.0)
			add_child(marcador_actual)
