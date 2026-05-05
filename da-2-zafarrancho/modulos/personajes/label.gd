class_name life_state extends Label

#POR ARREGLAR

var max_hp; 
var current_hp;

func _ready() -> void:
	#_on_health_manager_impacto_recibido(0)
	text = str(current_hp)

func _on_health_manager_impacto_recibido(vida_actual):
	current_hp = vida_actual
	#value = current_hp

"""
@onready var health_manager = get_parent().get_node("HealthManager")

func _ready():
	health_manager.health_changed.connect(_on_health_changed)
	_on_health_changed(health_manager.get_health()) # inicializa

func _on_health_changed(value):
	text = str(value)
"""
