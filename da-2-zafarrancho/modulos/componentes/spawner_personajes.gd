extends Node
class_name SpawnerPersonajes

var personajes_disponibles = {
	"base": preload("res://modulos/personajes/personaje_base.tscn"),
	#"arquero": preload("res://modulos/personajes/arquero.tscn")
	
}

func crear_personaje(tipo:String, jugador_id:int, indice:int):
	var pj = personajes_disponibles[tipo].instantiate()

	pj.position = Vector2(jugador_id * 200, indice * 100)
	pj.jugador_id = jugador_id
	pj.indice_en_equipo = indice

	return pj
