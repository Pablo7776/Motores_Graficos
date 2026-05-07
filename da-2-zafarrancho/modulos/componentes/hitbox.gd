extends Area2D

@export var damage := 1

@onready var collision = $CollisionShape2D


func _ready():

	collision.disabled = true


func activate(time := 0.6):

	collision.disabled = false

	await get_tree().create_timer(time).timeout

	collision.disabled = true


func _on_area_entered(area):
	print(area)

	print("golpe activado")

	if area.has_method("take_damage"):

		print("tiene hurtbox")

		area.take_damage(damage)
