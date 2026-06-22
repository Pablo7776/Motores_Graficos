extends Node
class_name SpawnerPersonajes


@export var personaje_base : PackedScene
@export var personaje_cazador : PackedScene
@export var personaje_otro : PackedScene

func crear_personaje(tipo:String, jugador_id:int, indice:int):
	var escena : PackedScene
	
	match tipo:
		"base":
			escena = personaje_base

		"cazador":
			escena = personaje_cazador
			
		"otro":
			escena = personaje_otro

	var pj = escena.instantiate()
	
	pj.position = Vector2(jugador_id * 200, indice * 100)
	pj.jugador_id = jugador_id
	pj.indice_en_equipo = indice

	return pj
