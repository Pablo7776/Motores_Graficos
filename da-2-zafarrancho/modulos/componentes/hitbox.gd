extends Area2D
class_name hitbox

@export var damage := 1

@onready var collision = $CollisionShape2D
@onready var player = get_parent()

func _ready():

	collision.disabled = true


func attack():

	set_direction(player.anim.flip_h)

	activate()


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


func set_direction(facing_left):

	if facing_left:
		scale.x = -1
	else:
		scale.x = 1
