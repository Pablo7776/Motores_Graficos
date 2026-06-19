extends Area2D

func _on_body_entered(body):
	body.get_node("Hurtbox").take_damage(3)
