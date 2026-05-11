extends CharacterBody2D
class_name PersonajeBase

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var anim = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var dado = $Dado

var jugador_id
var indice_en_equipo

func _ready():
	state_machine.init(self)
	
	dado.dado_valor.connect(_on_dado_valor)
	


func _on_cambiar_turno(pj, turno_actual): #✨Armado en Clase
	if pj == self:
		print("Es mi turno", self)
		set_physics_process(true)
		dado.activo = true
		dado.ya_tirado = false
		#$Timer.start(_on_dado_valor)
		
	else:
		set_physics_process(false)
		dado.activo = false
		print("no es mi turno", self)
"""
	if pj.jugador_id == jugador_id:
		print("Es el turno de:", jugador_id, indice_en_equipo)
	if not pj.jugador_id == jugador_id:
		state_machine.fuera_de_turno
"""

# Esta función recibe el valor del dado
func _on_dado_valor(valor):

	print("Valor del dado:", valor)

	# El timer dura lo mismo que el valor del dado
	$Timer.start(valor)

func play_animation(anim_name):
	anim.play(anim_name)


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	state_machine.update(delta)
	#Esto hace que se termine el turno con esc	
	if Input.is_action_just_pressed("ui_cancel") and is_on_floor():
			$Timer.stop()
			terminar_turno()
	move_and_slide()

func _on_timer_timeout() -> void:
	terminar_turno()

func terminar_turno():
	state_machine.change_state(state_machine.idle_state)
	$"../GestorDeTurnos".siguiente_turno()
	
