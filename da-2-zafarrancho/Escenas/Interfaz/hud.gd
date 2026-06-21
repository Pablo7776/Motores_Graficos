extends Node2D
class_name Hud

var pj_actual

func _on_dado_girando():
	$DadosTirados/AnimatedSprite2D.play()
	$DadosTirados/CPUParticles2D.emitting = true
	pass

func _on_dado_valor(valor):
	$DadosTirados/AnimatedSprite2D.stop()
	$DadosTirados/CPUParticles2D.emitting = false
	print("Valor del dado:", valor)

	$Timer.start(valor)


func _on_gestor_cambiar_turno(pj):

	$Timer.stop()
	# Desconectar dado anterior
	if pj_actual != null:

		if pj_actual.dado.dado_valor.is_connected(_on_dado_valor):

			pj_actual.dado.dado_valor.disconnect(_on_dado_valor)

	# Cambiar personaje actual
	pj_actual = pj

	# Conectar nuevo dado
	
	pj_actual.dado.dado_valor.connect(_on_dado_valor)
	pj_actual.dado.dados_girando.connect(_on_dado_girando)

	_mostrar_turno()


func _process(delta: float) -> void:

	$Tiempo.text = "Segundos: " + str(int($Timer.time_left))


func _mostrar_turno():

	$PJs_de_Jugador_1.text = (
		"Jugador: "
		+ str(pj_actual.jugador_id + 1)
		+ " Personaje: "
		+ str(pj_actual.indice_en_equipo + 1)
	)
