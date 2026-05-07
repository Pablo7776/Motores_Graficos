extends State

var attacking = true

func enter(player):

	attacking = true

	player.play_animation("Attack")

	await player.anim.animation_finished

	attacking = false


func update(player, delta):

	if attacking:
		return

	var direction = Input.get_axis("ui_left", "ui_right")

	player.velocity.x = direction * player.SPEED

	if direction != 0:
		player.anim.flip_h = direction < 0

	if player.is_on_floor():
		if direction == 0:
			player.state_machine.change_state(
				player.state_machine.idle_state
			)
		else:
			player.state_machine.change_state(
				player.state_machine.run_state
			)

func exit(player):
	pass
