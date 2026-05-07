extends State

func enter(player):
	player.play_animation("Run")
	print("CORRER")

func update(player, delta):

	var direction = Input.get_axis("ui_left", "ui_right")

	if direction == 0:
		player.state_machine.change_state(
			player.state_machine.idle_state
		)
		return

	player.velocity.x = direction * player.SPEED
	player.anim.flip_h = direction < 0

	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():

		player.velocity.y = player.JUMP_VELOCITY

		player.state_machine.change_state(
			player.state_machine.jump_state
		)

		return

	if Input.is_action_just_pressed("attack"):

		player.state_machine.change_state(
			player.state_machine.attack_state
		)

		return


func exit(player):
	player.velocity.x = 0
