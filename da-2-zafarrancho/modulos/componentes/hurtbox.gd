extends Area2D
class_name hurtbox

@onready var health_manager = get_parent().get_node("HealthManager")

@onready var player = get_parent()


func take_damage(amount: int):
	print("ataque recibido")

	if health_manager:
		health_manager.set_health(
			health_manager.health - amount
		)

	
	flash_damage()
	
	var hm = get_parent().get_node("HealthManager")
	
	print("cantidad de vida: ", hm.get_health())
	
func flash_damage():
	print("flash_damage")
	player.animacion.modulate = Color.RED

	await get_tree().create_timer(0.5).timeout

	player.animacion.modulate = Color.WHITE
