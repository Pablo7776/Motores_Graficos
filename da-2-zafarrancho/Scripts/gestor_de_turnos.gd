extends Node
class_name GestorDeTurnos

@export var cantidad_de_jugadores:int
@export var cantidad_de_pj_por_jugador:int
var lista_de_turnos:=[]
var matriz_de_jugadores_personajes:=[]
var turno_actual = 0
signal cambiar_turno(pj, turno_actual)

func _ready() -> void:
# Acá conecta una señal que se envía al apretar "iniciar partida" desde el menú de partida donde se establecen la cantida de jugadores y de personajes por jugador.
	var partida = get_node("MenuDePartida")
	partida.iniciar.connect(_on_menu_de_partida_iniciar)

#Acá se crean los grupos de pjs para cada jugador y se crea la lista de turnos
func _on_menu_de_partida_iniciar(cant_jugadores, cant_personajes) -> void:
	lista_de_turnos.clear()
	matriz_de_jugadores_personajes.clear()
	cantidad_de_jugadores = cant_jugadores
	cantidad_de_pj_por_jugador = cant_personajes
	var personaje = preload("res://modulos/personajes/personaje_base.tscn")
	for j in range(cantidad_de_jugadores):
		var lista_de_pjs:=[]
		for p in range(cantidad_de_pj_por_jugador):
			var nuevo_pj = personaje.instantiate()
			#Acá habría que agregarlo a la escena de nivel ¿O esto lo haría el propio pj al construirlo?
			#get_parent().add_child(nuevo_pj)
			#Acá se agrega al grupo del jugador j
			nuevo_pj.add_to_group("pjs_jugador_%d" %(j+1))
			#Necesitamos estas dos variables en el pj jugador_id e indice_en_equipo
			#Acá me parece que estoy rompiendo el encapsulamiento del pj, pero no estoy seguro
			nuevo_pj.jugador_id = j
			nuevo_pj.indice_en_equipo = p
			#Acá se agrega a la lista de pjs
			lista_de_pjs.append(nuevo_pj)
		#Mete todos los personajes de un jugador en su propia lista.
		matriz_de_jugadores_personajes.append(lista_de_pjs)
	crear_lista_de_turnos()

func crear_lista_de_turnos():
	for p in range(cantidad_de_pj_por_jugador):
		for j in range(cantidad_de_jugadores):
			var pj = matriz_de_jugadores_personajes[j][p]
			lista_de_turnos.append(pj)
		turno_actual = 0
		cambiar_turno.emit(lista_de_turnos[0], turno_actual)

func siguiente_turno():
	turno_actual = (turno_actual + 1) % lista_de_turnos.size()
	var pj = lista_de_turnos[turno_actual]
	cambiar_turno.emit(pj, turno_actual)
