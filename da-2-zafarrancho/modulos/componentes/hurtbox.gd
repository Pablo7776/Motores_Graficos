extends Area2D

@export var health_manager : Node

func take_damage(amount: int):
	print("ataque recibido")

	if health_manager:
		health_manager.set_health(
			health_manager.health - amount
		)

	
	get_parent().flash_damage()
	var hm = get_parent().get_node("HealthManager")
	
	print("cantidad de vida: ", hm.get_health())
