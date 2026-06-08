extends HBoxContainer

@onready var next: Button = $next
@onready var prev: Button = $prev
@onready var nombre_del_heroe: Label = $"Nombre del Heroe"

var heroes = ["Barbaro", "Mago","Cazador"]
var indice := 0

func _ready():
	next.pressed.connect(_siguiente)
	prev.pressed.connect(_anterior)
	actualizar_texto()

func _siguiente():
	indice = (indice + 1) % heroes.size()
	actualizar_texto()

func _anterior():
	indice = (indice - 1 + heroes.size()) % heroes.size()
	actualizar_texto()

func actualizar_texto():
	nombre_del_heroe.text = heroes[indice]
