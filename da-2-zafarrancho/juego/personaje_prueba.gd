extends CharacterBody2D
@export var escena_proyectil: PackedScene

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump = 0 
var jump_dir = 0

func _physics_process(delta: float) -> void:
	var valid_pos = position
	if jump > 0:
		
		for dir in [Vector2(jump_dir, 0), Vector2(jump_dir, -1), Vector2(jump_dir, -2), Vector2(jump_dir, -3), Vector2(jump_dir, -4), Vector2(jump_dir, -5)]:
			var pos_local = position + dir
			var pos_global = global_position + dir # Usamos la global para preguntar
			if $"../mapa".colission_normal(pos_global) == Vector2.ZERO:
				valid_pos = pos_local
		jump -= 1
		position = valid_pos
	if Input.is_action_just_pressed("ui_accept"): 
		disparar()
		return
		
		
	var walk = jump_dir
	
	# Usamos global_position + Vector2.DOWN para preguntar si tocamos el suelo
	if $"../mapa".colission_normal(global_position + Vector2.DOWN) != Vector2.ZERO:
		jump_dir = 0
		if Input.is_action_pressed("Jump"):
			if jump == 0:
				jump_dir = Input.get_axis("ui_left", "ui_right") 
				jump = 10
				
		walk = Input.get_axis("ui_left", "ui_right")
		
		valid_pos = position
		
	for dir in [Vector2(walk, -3), Vector2(walk, -2), Vector2(walk, -1), Vector2(walk, 0), Vector2(walk, 1), Vector2(walk, 2), Vector2(walk, 3)]:
		var pos_local = position + dir
		var pos_global = global_position + dir # Usamos la global para preguntar
		if $"../mapa".colission_normal(pos_global) == Vector2.ZERO:
			valid_pos = pos_local
			
	position = valid_pos



func disparar() -> void:
	var bala = escena_proyectil.instantiate()
	bala.global_position = global_position
	
	# 1. Obtenemos la posición del ratón en el mundo
	var posicion_raton = get_global_mouse_position()
	
	# 2. Calculamos la dirección desde el jugador hacia el ratón
	# direction_to() nos da un vector normalizado (de tamaño 1) apuntando allá
	var direccion = global_position.direction_to(posicion_raton)
	
	# 3. Multiplicamos esa dirección por la velocidad que queremos (ej. 600)
	bala.velocity = direccion * 600
	
	get_parent().add_child(bala)
