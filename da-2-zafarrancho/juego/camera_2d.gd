extends Camera2D


var target: CharacterBody2D = null

func _process(delta):
	if target != null:

		global_position = target.global_position
		
# Función de ayuda para cambiar el foco desde otro script
func enfocar_en(nuevo_target: CharacterBody2D):
	target = nuevo_target
