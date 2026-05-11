extends Camera2D

@export var velocidad_camara: float = 5.0 

var lista_gusanos: Array[Node] = []
var indice_actual: int = 0
var objetivo_actual: Node2D = null

func _ready() -> void:
	lista_gusanos = get_tree().get_nodes_in_group("personajes")
	
	#  Si hay personajes  en la escena, enfocar al primero
	if lista_gusanos.size() > 0:
		objetivo_actual = lista_gusanos[indice_actual]
		global_position = objetivo_actual.global_position # Salto instantáneo inicial

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cambiar_personaje"):
		cambiar_turno()
		
 #Mover la cámara suavemente hacia el objetivo actual en cada frame
	if objetivo_actual != null:
		# lerp  hace que el movimiento sea fluido
		global_position = global_position.lerp(objetivo_actual.global_position, velocidad_camara * delta)

func cambiar_turno() -> void:
	

	indice_actual = (indice_actual + 1) % lista_gusanos.size()
	

	objetivo_actual = lista_gusanos[indice_actual]
