extends Node
class_name GestorDeTurnosV2
@export var jugadores:int #cantidad de jugadores
@export var personajes:int #cantidad de pjs por jugador
var lista_jugadores := [] #lista de los jugadores activos
var equipos := {}
var turno_jugador:int #contador de cuál jugador va
var turno_personaje:int #contador de cuál pj va del jugador
var ganador:int
signal turno_de(node)
signal jugador_vencido(n:int)
signal victoria(ganador)
@onready var hud = owner.find_child("HUD")
@export var camara: Camera2D
@onready var spawner = get_parent().get_node("SpawnerPersonajes")
var personaje_activo

func _ready() -> void:
# Acá conecta una señal que se envía al apretar "iniciar partida" desde el menú de partida donde se establecen la cantida de jugadores y de personajes por jugador.
	get_parent().iniciar.connect(_on_menu_de_partida_iniciar)  #✨Armado en Clase
	turno_de.connect(hud._on_gestor_cambiar_turno) #como llama a la función en el hud se puede mejorar para que sea mas claro
#acá se crean los personajes, las listas de jugadores y de equipos, a partir de los datos del menú de partida
func _on_menu_de_partida_iniciar(cant_jugadores, cant_personajes, clases_elegidas: Array = []) -> void:
	lista_jugadores.clear()
	equipos.clear()
	ganador = 0
	jugadores = cant_jugadores
	personajes = cant_personajes
	turno_personaje = 0
	var lista_clases_actuales = clases_elegidas
	await get_tree().create_timer(0.5).timeout
	var espacio_fisico = camara.get_world_2d().direct_space_state
	#var personaje = preload("res://modulos/personajes/personaje_base.tscn")
	for i in range(jugadores):
		equipos[i] = {"turno_propio": turno_personaje, "personajes_propios":[]}
		for j in range(personajes):
			var tipo_de_clase:String
			if lista_clases_actuales.size() > 0:
				var n_personaje = "personaje" + str(j+1)
				tipo_de_clase = lista_clases_actuales[i][n_personaje]
			#var nuevo_pj = personaje.instantiate()
			#var nuevo_pj = spawner.crear_personaje("base")
			var nuevo_pj = spawner.crear_personaje(tipo_de_clase, i, j, espacio_fisico)
			#nuevo_pj.position = Vector2(i * 200, j * 100)
			#nuevo_pj.jugador_id = i
			#nuevo_pj.indice_en_equipo = j
			get_parent().add_child(nuevo_pj)			
			turno_de.connect(nuevo_pj._on_cambiar_turno) #como llama a la función en el pj se puede mejorar para que sea mas claro
			nuevo_pj.mori.connect(_on_pj_mori)
			spawner.ubicar_en_suelo(nuevo_pj, espacio_fisico)
			equipos[i]["personajes_propios"].append(nuevo_pj)
	primer_turno()

func primer_turno():
	turno_jugador = randi_range(0, jugadores-1)
	var pj_activo = equipos[turno_jugador]["personajes_propios"][turno_personaje]
	turno_de.emit(pj_activo)
	camara.enfocar_en(pj_activo)

func siguiente_turno():
	turno_jugador = (turno_jugador + 1) % equipos.size()
	seleccionar_pj()

func seleccionar_pj():
	if equipos[turno_jugador]["personajes_propios"].is_empty():
		siguiente_turno()
		return
	equipos[turno_jugador]["turno_propio"]= (equipos[turno_jugador]["turno_propio"]+1)%equipos[turno_jugador]["personajes_propios"].size()
	turno_personaje = equipos[turno_jugador]["turno_propio"]
	var pj_activo = equipos[turno_jugador]["personajes_propios"][turno_personaje]
	if !is_instance_valid(pj_activo):
		equipos[turno_jugador]["personajes_propios"].erase(pj_activo)
		siguiente_turno()
		return
	personaje_activo = pj_activo
	turno_de.emit(pj_activo)
	camara.enfocar_en(pj_activo)

func _on_pj_mori(pj_muerto):
	var jugador_id = pj_muerto.jugador_id
	equipos[jugador_id]["personajes_propios"].erase(pj_muerto)
	pj_muerto.queue_free()
	print("personaje eliminado: ", pj_muerto)
	if pj_muerto == self:
		siguiente_turno()
	if equipos[jugador_id]["personajes_propios"].size() == 0:
		jugador_vencido.emit(jugador_id+1)
		print("Se murieron todos los PJ del jugador", jugador_id+1)
	_comprobar_victoria()

func _comprobar_victoria():
	var vivos = []
	for v in range(equipos.size()):
		if !equipos[v]["personajes_propios"].is_empty():
			vivos.append(v)
	if vivos.size() == 1:
		ganador = vivos[0]+1
		print("Ganó el jugador", ganador)
		victoria.emit(ganador)
