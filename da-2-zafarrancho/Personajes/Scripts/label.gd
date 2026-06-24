class_name life_state extends Label


@onready var health_manager = get_parent().get_node("HealthManager")

func _ready():
	health_manager.health_changed.connect(_on_health_changed)
	_on_health_changed(health_manager.get_health()) # inicializa

func _on_health_changed(value):
	text = str(value)
