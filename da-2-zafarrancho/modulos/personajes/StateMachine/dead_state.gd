extends State

func enter(player):

	player.velocity = Vector2.ZERO

	player.modulate = Color.BLACK

	print("murio")
	
	await get_tree().create_timer(1.0).timeout

	player.queue_free()
