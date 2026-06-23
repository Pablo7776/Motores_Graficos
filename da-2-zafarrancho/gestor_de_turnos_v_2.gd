extends Node
class_name GestorDeTurnosV2
@export var jugadores:int #cantidad de jugadores
@export var personajes:int #cantidad de pjs por jugador
var lista_jugadores := [] #lista de los jugadores activos
var equipos := {}
var turno_jugador:int #contador de cuál jugador va
var turno_personaje:int #contador de cuál pj va del jugador
signal turno_de(node)
signal jugador_vencido(n:int)
signal partida_terminada(jugador_ganador: int)
@onready var hud = owner.find_child("HUD")
@export var camara: Camera2D
@onready var spawner = get_parent().get_node("SpawnerPersonajes")

func _ready() -> void:
# Acá conecta una señal que se envía al apretar "iniciar partida" desde el menú de partida donde se establecen la cantida de jugadores y de personajes por jugador.
	get_parent().iniciar.connect(_on_menu_de_partida_iniciar)  #✨Armado en Clase
	turno_de.connect(hud._on_gestor_cambiar_turno) #como llama a la función en el hud se puede mejorar para que sea mas claro
	partida_terminada.connect(_on_partida_terminada)
	
#acá se crean los personajes, las listas de jugadores y de equipos, a partir de los datos del menú de partida
func _on_menu_de_partida_iniciar(cant_jugadores, cant_personajes) -> void:
	lista_jugadores.clear()
	equipos.clear()
	jugadores = cant_jugadores
	personajes = cant_personajes
	await get_tree().create_timer(0.5).timeout
	
	turno_personaje = 0
	turno_personaje = 0
	#var personaje = preload("res://modulos/personajes/personaje_base.tscn")
	for i in range(jugadores):
		equipos[i] = {"turno_propio": turno_personaje, "personajes_propios":[]}
		for j in range(personajes):
			#var nuevo_pj = personaje.instantiate()
			#var nuevo_pj = spawner.crear_personaje("base")
			var nuevo_pj = spawner.crear_personaje("base", i, j)
			#nuevo_pj.position = Vector2(i * 200, j * 100)
			#nuevo_pj.jugador_id = i
			#nuevo_pj.indice_en_equipo = j
			nuevo_pj.global_position = obtener_posicion_suelo()
			turno_de.connect(nuevo_pj._on_cambiar_turno) #como llama a la función en el pj se puede mejorar para que sea mas claro
			nuevo_pj.mori.connect(_on_pj_mori)
			get_parent().add_child(nuevo_pj)
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
	turno_de.emit(pj_activo)
	camara.enfocar_en(pj_activo)

func _on_pj_mori(pj_muerto):
	var jugador_id = pj_muerto.jugador_id
	equipos[jugador_id]["personajes_propios"].erase(pj_muerto)
	pj_muerto.queue_free()
	print("personaje eliminado: ", pj_muerto)
	
	if equipos[jugador_id]["personajes_propios"].size() == 0:
		jugador_vencido.emit(jugador_id+1)
		print("Se murieron todos los PJ del jugador", jugador_id+1)
		_verificar_fin_de_partida()
		if _partida_terminada():
			return 
	siguiente_turno()
	
func _on_partida_terminada(jugador_ganador: int) -> void:
	DatosPartida.jugador_ganador = jugador_ganador
	call_deferred("_cambiar_a_victoria")

func _cambiar_a_victoria() -> void:
	get_tree().change_scene_to_file("res://victoria.tscn")

func _jugadores_con_vida() -> Array:
	var vivos = []
	for jugador_id in equipos.keys():
		if equipos[jugador_id]["personajes_propios"].size() > 0:
			vivos.append(jugador_id)
	return vivos
func _verificar_fin_de_partida() -> void:
	var vivos = _jugadores_con_vida()
	if vivos.size() == 1:
		partida_terminada.emit(vivos[0])

func _partida_terminada() -> bool:
	return _jugadores_con_vida().size() <= 1

func obtener_posicion_suelo(intentos: int = 0) -> Vector2:
	# Si después de 50 intentos no encuentra piso, lo tira en el medio por seguridad
	if intentos > 50:
		return Vector2(randf_range(100, 1000), 0)

	#  Elegimos un punto X aleatorio (ajusta el 1100 al ancho de tu mapa)
	var x_aleatorio = randf_range(50, 1100) 
	
	#  Trazamos un rayo láser invisible desde el cielo (-500) hasta el abismo (2000)
	var inicio = Vector2(x_aleatorio, -500)
	var fin = Vector2(x_aleatorio, 2000)
	var query = PhysicsRayQueryParameters2D.create(inicio, fin)
	
	#  Disparamos el rayo
	var espacio = camara.get_world_2d().direct_space_state
	var resultado = espacio.intersect_ray(query)

	# Si chocó con el suelo (TileMap), devolvemos esa coordenada
	if resultado:
		return resultado.position
	else:
		# Si cayó al vacío, volvemos a intentar
		return obtener_posicion_suelo(intentos + 1)
