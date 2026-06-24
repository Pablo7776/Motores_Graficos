extends State

var sonido = preload("res://Audio/Escenas/audio_manager.tscn").instantiate()

func enter(player):

	player.velocity.x = 0

	player.play_animation("Attack")

	AudioManager.play_hacha()

	print("paso por aquí")

	var hitbox = player.visuales_flipeables.get_node("Hitbox")
	hitbox.set_direction(player.animacion.flip_h)
	hitbox.attack()

	await player.animacion.animation_finished

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
