extends CharacterBody2D
class_name PersonajeBase

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var state_machine = $StateMachine

var jugador_id
var indice_en_equipo

func _ready():
	state_machine.init(self)


func play_animation(anim_name):
	anim.play(anim_name)


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	state_machine.update(delta)
	move_and_slide()
