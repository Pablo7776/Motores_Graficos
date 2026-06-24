extends PersonajeBase
class_name Castigador


func asignar_animacion():
	var escena_sprite = preload("res://Escenas/Personajes/sprite_pj_1.tscn")

	animacion = escena_sprite.instantiate()
	visuales_flipeables.add_child(animacion)

	for child in visuales_flipeables.get_children():
		if child.has_method("play"):
			animacion = child
			break

func setear_vida_max():
	$HealthManager.set_max_health(6)
	$HealthManager.set_health(6)

func setear_tiempo():
	$Dado.tiempo_min=2
	$Dado.tiempo_max=10
