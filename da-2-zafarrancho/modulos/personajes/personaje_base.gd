extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D

var state_machine

func _ready():
	state_machine = load("res://modulos/personajes/StateMachine/StateMachine.tscn").instantiate()
	add_child(state_machine)
	state_machine.init(self)

func play_animation(anim_name):
	anim.play(anim_name)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	state_machine.update(delta)
	move_and_slide()
