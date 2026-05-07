extends Area2D

@export var damage := 20

func _on_body_entered(body):

	if body.has_method("take_damage"):
		body.get_node("Hurtbox").take_damage(damage)
