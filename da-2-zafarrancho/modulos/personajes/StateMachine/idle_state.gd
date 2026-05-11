extends State

func enter(player):
	player.play_animation("Idle")
	

func update(player, delta):
	player.mover_horizontal(0)
	var direction = Input.get_axis("ui_left", "ui_right")
	# 2. Transición a Correr
	if direction != 0:
		player.state_machine.change_state(player.state_machine.run_state)
		return

	# 3. Transición a Saltar
	if Input.is_action_just_pressed("ui_accept") and player.tocando_el_suelo():
		player.state_machine.change_state(player.state_machine.jump_state)
		return
	# Esto te saca de tu turno
	"""
	if Input.is_action_just_pressed("ui_cancel"):
		print("ando")
		player.state_machine.change_state(player.state_machine.fuera_de_turno)
	"""
	if direction != 0:
		player.state_machine.change_state(player.state_machine.run_state)

	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		player.state_machine.change_state(player.state_machine.jump_state)
