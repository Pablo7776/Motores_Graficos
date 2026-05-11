extends Node2D

# Variables de física
var velocity := Vector2.ZERO
var gravedad := 600.0 # Ajusta esto para que caiga más rápido o más lento
var radio_explosion := 40 # El tamaño del agujero que hará

# Variable para guardar la referencia al mapa
var nodo_mapa: Node

func _ready() -> void:
	# Buscamos el mapa en cuanto el proyectil aparece en el mundo.
	# Suponemos que el proyectil será "hermano" del mapa.
	nodo_mapa = get_parent().get_node_or_null("mapa")

func _physics_process(delta: float) -> void:
	# Aplicamos la gravedad a la velocidad
	velocity.y += gravedad * delta
	
	# Movemos el proyectil
	global_position += velocity * delta
	
	# Opcional: Hacer que la bala apunte hacia donde está yendo
	rotation = velocity.angle()
	
	# Le preguntamos al mapa si en nuestra posición actual hay un píxel sólido
	if nodo_mapa != null:
		if nodo_mapa.colission_normal(global_position) != Vector2.ZERO:
			explotar()

func explotar() -> void:
	# Llamamos a la función de explosión de tu mapa
	nodo_mapa.explosion(global_position, radio_explosion)
	
	queue_free()
