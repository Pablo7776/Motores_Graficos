extends State

func enter(player):

	player.velocity.x = 0

	player.play_animation("Attack")

	var hitbox = player.get_node("Hitbox")

	hitbox.attack()

	await player.anim.animation_finished

	var direction = Input.get_axis("mover_izquierda", "mover_derecha")

	if player.is_on_floor():

		if direction == 0:
			player.state_machine.change_state(
				player.state_machine.idle_state
			)
		else:
			player.state_machine.change_state(
				player.state_machine.run_state
			)

	else:

		player.state_machine.change_state(
			player.state_machine.jump_state
		)


func update(player, delta):
	pass


func exit(player):
	pass
