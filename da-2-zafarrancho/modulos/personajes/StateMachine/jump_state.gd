extends State

func enter(player):
	print("SALTOOO")
	player.play_animation("Jump")
	print("SALTOOO")
 
func update(player, delta):
	var direction = Input.get_axis("ui_left", "ui_right")

	# movimiento en el aire
	player.velocity.x = direction * player.SPEED
	
	if direction != 0:
		player.anim.flip_h = direction < 0

	# cuando vuelve al piso
	if player.is_on_floor():
		if direction == 0:
			player.state_machine.change_state(player.state_machine.idle_state)
		else:
			player.state_machine.change_state(player.state_machine.run_state)

func exit(player):
	pass
