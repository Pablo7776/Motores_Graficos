extends Node
class_name SpawnerPersonajes


@export var personaje_base : PackedScene
@export var personaje_cavador : PackedScene
@export var personaje_castigador : PackedScene

func crear_personaje(tipo:String, jugador_id:int, indice:int, espacio: PhysicsDirectSpaceState2D):
	var escena : PackedScene
	
	match tipo:
		"base":
			escena = personaje_base
		"cavador":
			escena = personaje_cavador
		"castigador":
			escena = personaje_castigador

	var pj = escena.instantiate()
	
	pj.jugador_id = jugador_id
	pj.indice_en_equipo = indice

	return pj

func ubicar_en_suelo(pj: Node2D, espacio: PhysicsDirectSpaceState2D, intentos: int = 0):
	if intentos > 50:
		pj.global_position = Vector2(randf_range(100, 1000), 0)
		return

	var x_aleatorio = randf_range(50, 1100) 
	var inicio = Vector2(x_aleatorio, -500)
	var fin = Vector2(x_aleatorio, 2000)
	var query = PhysicsRayQueryParameters2D.create(inicio, fin)
	
	var resultado = espacio.intersect_ray(query)

	if resultado:
		pj.global_position = resultado.position - Vector2(0, 15)
	else:
		ubicar_en_suelo(pj, espacio, intentos + 1)
