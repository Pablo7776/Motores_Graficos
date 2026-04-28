extends State
 #✨Armado en Clase
func enter(player):
	player.player_animation("Idle")
	player.set_process(false)
	player.set_physics_process(false)

func update(player, delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print("ando")
		player.state_machine.change_state(player.state_machine.idle_state)

func exit(player):
	player.set_process(true)
	player.set_physics_process(true)
