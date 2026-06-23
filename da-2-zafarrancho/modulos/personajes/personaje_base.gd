extends CharacterBody2D
class_name PersonajeBase

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var animacion
@onready var visuales_flipeables: Node2D = $VisualesFlipeables
@onready var state_machine = $StateMachine
@onready var dado = $Dado
@onready var gestor_de_turnos = get_parent().get_node("GestorDeTurnosV2")

var jugador_id = 0
var indice_en_equipo
var es_mi_turno = false

signal mori(personaje)


func _ready():
	#var audio = preload("res://Escenas/audio_manager.tscn").instantiate()
	asignar_animacion()
	state_machine.init(self)
	dado.dado_valor.connect(_on_dado_valor)
	$ContadorDeVida.actualizar_barra()



func _on_cambiar_turno(pj): #✨Armado en Clase
	if pj == self:
		es_mi_turno = true
		print("Es mi turno", self)
		dado.activo = true
		dado.ya_tirado = false
		#set_physics_process(false)
		#$Timer.start(0)
		state_machine.change_state(state_machine.esperando_state)
		
	else:
		es_mi_turno = false
		#set_physics_process(false)
		dado.activo = false
		$Timer.stop()
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
	set_physics_process(true)
	state_machine.change_state(state_machine.idle_state)

#func asignar_animacion():
	#"""
	#if (jugador_id+1)%2 ==0:
		#animacion = preload("res://Escenas/Personajes/sprite_pj_2.tscn").instantiate()
	#else:
		#animacion = preload("res://Escenas/Personajes/sprite_pj_1.tscn").instantiate()
	#add_child(animacion)
	#move_child(animacion,0)
	#"""
	##animacion = $VisualesFlipeables/SpritePJ1
	
func asignar_animacion():
	var escena_sprite : PackedScene
	
	# Decide qué escena cargar dependiendo del jugador_id
	if (jugador_id + 1) % 2 == 0:
		escena_sprite = preload("res://Escenas/Personajes/sprite_pj_2.tscn")
	else:
		escena_sprite = preload("res://Escenas/Personajes/sprite_pj_1.tscn")
		
	# Instancia la escena y la guarda en la variable
	animacion = escena_sprite.instantiate()
	
	# Lo añade como hijo específicamente de VisualesFlipeables
	visuales_flipeables.add_child(animacion)
	for child in visuales_flipeables.get_children():
		if child.has_method("play"):
			animacion = child
			break
	
	
func play_animation(anim_name):
	print(animacion)
	animacion.play(anim_name)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	state_machine.update(delta)
	move_and_slide()

	
func _on_timer_timeout() -> void:
	terminar_turno()

func terminar_turno():
	state_machine.change_state(state_machine.idle_state)
	await get_tree().create_timer(0.30).timeout
	$"../GestorDeTurnosV2".siguiente_turno()
	

func _on_health_manager_dead() -> void:
	$StateMachine.change_state(state_machine.dead_state)
	mori.emit(self)





func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		#  Obtenemos la coordenada exacta
		var posicion_del_hacha = visuales_flipeables.get_node("Hitbox").global_position
		var pos_local = body.to_local(posicion_del_hacha)
		var celda_central = body.local_to_map(pos_local)
		
		if body.has_method("crear_crater"):
			body.crear_crater(posicion_del_hacha)
