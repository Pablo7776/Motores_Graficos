extends PanelContainer

@onready var selector1: Selector = $VBoxContainer/HBoxContainer
@onready var selector2: Selector = $VBoxContainer/HBoxContainer2
@onready var selector3: Selector = $VBoxContainer/HBoxContainer3
@onready var selector4: Selector = $VBoxContainer/HBoxContainer4

func get_data() -> Dictionary:
	return {
		"personaje1": selector1.get_personaje(),
		"personaje2": selector2.get_personaje(),
		"personaje3": selector3.get_personaje(),
		"personaje4": selector4.get_personaje()
	}
	
