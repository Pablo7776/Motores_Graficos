extends Node2D

@export var character_scene: PackedScene 
@export var terrain_collision_mask: int = 1 # Asegúrate de usar la capa (layer) donde está tu terreno
var limite_izquierdo: float = 0.0 
var limite_derecho: float = 1250.0
var altura_cielo: float = -1000.0
var profundidad_abismo: float = 2000.0
var ajuste_pies_y: float = 15.0


func _ready():

	pass

func spawn_team(amount: int):
	await get_tree().create_timer(1.0).timeout

	for i in range(amount):
		# Elegir una posición X aleatoria entre 100 y 1000 (ajusta según tu mapa)
		var random_x = randf_range(50.0, 1870.0)
		spawn_single_character(random_x)

func spawn_single_character(x_position: float):
	var start_pos = Vector2(x_position, -1000)
	
	var end_pos = Vector2(x_position, 2000)

	#  Preparar la consulta espacial
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collision_mask = terrain_collision_mask

	#  Lanzar el rayo
	var result = space_state.intersect_ray(query)

	#  Evaluar el resultado
	if result:
		var ground_position = result.position
		print("¡Rayo golpeó algo en la posición! ", ground_position) 
		
		var character = character_scene.instantiate()
		add_child(character)
		
		character.global_position = ground_position - Vector2(0, ajuste_pies_y)
		print("Personaje movido a: ", character.global_position)
		
	else:
		print("El rayo en X: ", x_position, " cayó al vacío.") # <-- NUEVO
		spawn_single_character(randf_range(limite_izquierdo, limite_derecho))
