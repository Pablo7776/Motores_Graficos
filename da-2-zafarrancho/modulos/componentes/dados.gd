extends Node2D
class_name Dado

signal dado_valor(valor)

var cara := 1
var girando := false
var activo := false

@onready var label = $Label


func _ready():

	randomize()

	actualizar_visual()


func _input(event):

	# Si no es mi turno, ignoro input
	if not activo:
		return

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:

			if not girando:
				tirar_dado()


func tirar_dado():

	girando = true

	# Cantidad de cambios visuales antes de parar
	var vueltas = randi_range(10, 20)

	for i in vueltas:

		cara = randi_range(1, 20)

		actualizar_visual()

		await get_tree().create_timer(0.07).timeout

	dado_valor.emit(cara)

	girando = false

	print("Resultado final: ", cara)


func actualizar_visual():

	label.text = str(cara)
