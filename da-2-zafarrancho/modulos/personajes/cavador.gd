extends PersonajeBase
class_name Cavador

func asignar_animacion():
	var escena_sprite = preload("res://Escenas/Personajes/sprite_pj_2.tscn")

	animacion = escena_sprite.instantiate()
	visuales_flipeables.add_child(animacion)

	for child in visuales_flipeables.get_children():
		if child.has_method("play"):
			animacion = child
			break
