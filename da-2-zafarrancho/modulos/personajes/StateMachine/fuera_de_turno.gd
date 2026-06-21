extends State
#✨Armado en Clase
func enter(player):
	player.play_animation("Idle")
	#player.set_process(false)
	#player.set_physics_process(false)
	player.terminar_turno()
	

func update(player, delta):
	pass
		
func exit(player):
	#player.set_process(true)
	#player.set_physics_process(true)
	pass

func terminar_turno(player):
	print("Termina turno:", name)
	player.state_machine.change_state(player.state_machine.idle_state)
	$"../GestorDeTurnos".siguiente_turno()
