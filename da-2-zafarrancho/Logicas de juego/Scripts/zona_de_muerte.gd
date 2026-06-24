extends Area2D


func _on_body_entered(body):
	if body is PersonajeBase:
		if body.es_mi_turno:
			$"../GestorDeTurnosV2".siguiente_turno()
		var gestor_de_vida = body.get_node("HealthManager")
		var vida_actual = gestor_de_vida.get_health()
		body.get_node("Hurtbox").take_damage(vida_actual)
