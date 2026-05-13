extends State

func enter(player):
	player.play_animation("Idle")

func update(player, delta):

	var direction = Input.get_axis("mover_izquierda", "mover_derecha")

	if direction != 0:
		player.state_machine.change_state(
			player.state_machine.run_state
		)

	if Input.is_action_just_pressed("saltar") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		player.state_machine.change_state(
			player.state_machine.jump_state
		)

	if Input.is_action_just_pressed("atacar"):
		player.state_machine.change_state(
			player.state_machine.attack_state
		)
