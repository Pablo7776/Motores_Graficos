extends PanelContainer

@onready var selector1: Selector = $VBoxContainer/HBoxContainer
@onready var selector2: Selector = $VBoxContainer/HBoxContainer2

func get_data() -> Dictionary:
	return {
		"personaje1": selector1.get_personaje(),
		"personaje2": selector2.get_personaje()
	}
	
