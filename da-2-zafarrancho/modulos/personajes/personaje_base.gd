extends CharacterBody2D
class_name PersonajeBase

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animacion
@onready var state_machine = $StateMachine
@onready var mapa = $"../mapa"

var jugador_id
@onready var dado = $Dado
@onready var gestor_de_turnos = get_parent().get_node("res://Scripts/gestor_de_turnos.gd")

var jugador_id = 0
var indice_en_equipo
signal mori(jugador_id,indice_en_equipo)


func _ready():
	asignar_animacion()
	state_machine.init(self)
	
@export var duracion_salto: int = 10
@export var escalones_salto: Array[int] = [0, -1,-2,-3,-4,-5]
	dado.dado_valor.connect(_on_dado_valor)



func _on_cambiar_turno(pj, turno_actual): #✨Armado en Clase
	if pj == self:
		print("Es mi turno", self)
		dado.activo = true
		dado.ya_tirado = false
		set_physics_process(false)
		#$Timer.start(0)
		
	else:
		set_physics_process(false)
		dado.activo = false
		$Timer.stop()
		print("no es mi turno", self)
"""
	if pj.jugador_id == jugador_id:
		print("Es el turno de:", jugador_id, indice_en_equipo)
	if not pj.jugador_id == jugador_id:
		state_machine.fuera_de_turno
"""

func mover_horizontal(direccion: int) -> void:
	
	if direccion != 0:
		var destino = global_position + Vector2(direccion, 0)
		
		if mapa.colission_normal(destino) == Vector2.ZERO:
			position.x += direccion
		else:
			# Si hay pared, intentamos subir escalones (máximo 3 píxeles de alto)
			for escalon in range(1, 4):
				if mapa.colission_normal(destino + Vector2(0, -escalon)) == Vector2.ZERO:
					position += Vector2(direccion, -escalon)
					break 
					
	for caida in range(3):
		if mapa.colission_normal(global_position + Vector2(0, 1)) == Vector2.ZERO:
			position.y += 1
		else:
			break
			
	if mapa.colission_normal(global_position) != Vector2.ZERO:
		position.y -= 1
func tocando_el_suelo() -> bool:
	return mapa.colission_normal(global_position + Vector2.DOWN) != Vector2.ZERO
	
	
func play_animation(anim_name):
	anim.play(anim_name)
	
# Esta función recibe el valor del dado
func _on_dado_valor(valor):

	print("Valor del dado:", valor)

	# El timer dura lo mismo que el valor del dado
	$Timer.start(valor)
	set_physics_process(true)

func asignar_animacion():
	if (jugador_id+1)%2 ==0:
		animacion = preload("res://Escenas/Personajes/sprite_pj_2.tscn").instantiate()
	else:
		animacion = preload("res://Escenas/Personajes/sprite_pj_1.tscn").instantiate()
	add_child(animacion)
	move_child(animacion,0)


func play_animation(anim_name):
	print(animacion)
	animacion.play(anim_name)

func _physics_process(delta):
	
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
	

func _on_health_manager_dead() -> void:
	$StateMachine.change_state(state_machine.dead_state)
	mori.emit()
