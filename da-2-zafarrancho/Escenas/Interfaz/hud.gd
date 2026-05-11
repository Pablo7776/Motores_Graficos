extends Node2D
class_name Hud
var pj_actual


func _ready() -> void:
	#dado.dado_valor.connect(_on_dado_valor)
	#$Timer.start(30)
	pass
func _on_dado_valor(valor):

	print("Valor del dado:", valor)

	# El timer dura lo mismo que el valor del dado
	$Timer.start(valor)

func _on_gestor_cambiar_turno(pj, turno_actual):
	pj_actual = pj

	# Conectar el dado del personaje actual
	pj_actual.dado.dado_valor.connect(_on_dado_valor)

	_mostrar_turno()

func _process(delta: float) -> void:
	$Tiempo.set_text(str("Segundos:", int($Timer.get_time_left())))

func _mostrar_turno():
	$PJs_de_Jugador_1.set_text("Jugador: " + str(pj_actual.jugador_id+1) + " Personaje: " + str(pj_actual.indice_en_equipo+1))
