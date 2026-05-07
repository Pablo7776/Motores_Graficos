extends State

func enter(player):
	print("AAAAAA")
	player.velocity.x = 0

	player.play_animation("Attack")
	
	player.hitbox.activate()

	await player.anim.animation_finished

	var direction = Input.get_axis("ui_left", "ui_right")

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
