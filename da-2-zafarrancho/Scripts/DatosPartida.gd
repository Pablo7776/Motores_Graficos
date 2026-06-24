extends Node

var cantidad_jugadores: int = 0
var personajes_por_jugador: int = 0
var personajes_seleccionados: Array = []
var jugador_ganador := -1

func _ready():
	debug()

func debug():
	print("\n========== DATOS PARTIDA ==========")

	print("Cantidad jugadores:", cantidad_jugadores)
	print("Personajes por jugador:", personajes_por_jugador)

	print("personajes_seleccionados:")
	print(JSON.stringify(personajes_seleccionados, "\t"))

	print("===================================\n")
