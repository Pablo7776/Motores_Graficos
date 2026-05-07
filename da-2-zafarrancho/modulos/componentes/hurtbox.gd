extends Area2D

@export var health_manager : Node

func take_damage(amount):

	if health_manager:
		health_manager.take_damage(amount)
