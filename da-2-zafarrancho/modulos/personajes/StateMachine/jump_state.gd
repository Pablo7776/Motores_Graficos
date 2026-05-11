extends State

var tiempo_salto = 0

func enter(player):
	player.play_animation("Jump")
	# Usamos la variable que exportamos en el jugador, o ponle 10 directamente
	tiempo_salto = player.duracion_salto 

func update(player, delta):
	# Si se nos acabó el impulso, caemos y pasamos a Idle
	if tiempo_salto <= 0:
		player.state_machine.change_state(player.state_machine.idle_state)
		return
		
	# AQUÍ DECLARAMOS 'direction'
	var direction = Input.get_axis("ui_left", "ui_right") 
	
	# Giramos el sprite en el aire si nos movemos
	if direction != 0:
		player.anim.flip_h = direction < 0
	
	var mejor_pos = player.position
	
	# Leemos la constante/variable que guardamos en el jugador
	for altura_y in player.escalones_salto:
		
		# Unimos la dirección con la altura para probar
		var vector_direccion = Vector2(direction, altura_y)
		
		if player.mapa.colission_normal(player.global_position + vector_direccion) == Vector2.ZERO:
			mejor_pos = player.position + vector_direccion
			
	player.position = mejor_pos
	tiempo_salto -= 1

func exit(player):
	pass
