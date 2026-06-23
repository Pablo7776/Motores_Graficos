extends Control

@onready var hbox : HBoxContainer = $Panel/HBoxContainer
@onready var agregar_jugador: Button = $"Panel/agregar jugador"

const max_jugadores := 4
const jugadores_iniciales := 2
const player_card = preload("res://Escenas/player_card.tscn")

func _ready():
	var faltan = jugadores_iniciales - hbox.get_child_count()
	for i in faltan:
		var card = player_card.instantiate()
		hbox.add_child(card)
	_actualizar_labels()
	_actualizar_botones_eliminar()
	_actualizar_boton_agregar()

func _actualizar_labels() -> void:
	var cards = hbox.get_children()
	for i in cards.size():
		var card = cards[i]
		var label = card.get_node_or_null("Label")
		if label:
			label.text = "JUGADOR %d" % (i + 1)

func _actualizar_botones_eliminar() -> void:
	var cards = hbox.get_children()
	var hay_mas_de_dos = cards.size() > 2
	for card in cards:
		var boton_x = card.get_node_or_null("Button")
		if boton_x:
			boton_x.visible = hay_mas_de_dos
			if not boton_x.pressed.is_connected(_eliminar_card.bind(card)):
				boton_x.pressed.connect(_eliminar_card.bind(card))

func _actualizar_boton_agregar() -> void:
	agregar_jugador.visible = hbox.get_child_count() < max_jugadores
	
func _eliminar_card(card: Node) -> void:
	card.queue_free()
	await get_tree().process_frame
	_actualizar_labels()
	_actualizar_botones_eliminar()

func _on_agregar_jugador_pressed() -> void:
	if hbox.get_child_count() >= max_jugadores:
		return
	var card = player_card.instantiate()
	hbox.add_child(card)
	_actualizar_labels()
	_actualizar_botones_eliminar()
	_actualizar_boton_agregar()

func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")

func _on_continuar_pressed() -> void:
	var cards = hbox.get_children()

	DatosPartida.cantidad_jugadores = cards.size() 
	DatosPartida.personajes_seleccionados = []

	for i in range(cards.size()):
		var card = cards[i]

		DatosPartida.personajes_seleccionados.append(card.get_data())

		DatosPartida.debug()
	get_tree().change_scene_to_file("res://juego/main.tscn")
