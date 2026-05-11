class_name HealthManager extends Node

signal max_healt_changed(diff: int)
signal health_changed(diff: int) # Es una herramienta o funcionalidad utilizada para comparar para identificar exactamente qué ha cambiado entre ellos. Ejem: Vida = 100 → 80 → diff = -20
signal dead

@export var state_machine : Node
@export var max_health: int : set = set_max_health, get = get_max_health
#De esta forma exporto la variable como parametro modificable mediante el inspector y lo modifico como nodo hijo desde la escena del PJ a quien se lo instancie 
@export var inmportality: bool = false : set = set_inmortality, get = get_inmortality
#Con esta variable le doy un x tiempo de inmortalidad al PJ cuando aparece (No creo que sea necesariio en el juego pero lo dejo pinchado para probar), haciendolo bool lo transformo en un parametro de on/off en el inspector

var inmportality_timer: Timer = null #El timer para contar los segundo de importalidad en el momento del spawn 

@onready var health: int = max_health : set = set_health, get = get_health


func set_max_health(value: int): #Nota para mi: Es una variable numérica (generalmente float o int) que representa el estado actual dentro de un rango definido de números. Permite que el jugador ajuste parametros y los almacena, representa el progreso muy usado para UI y emite una señal cuando esto es modificado 
	#Aca cargo la vida maxima correspondiente del PJ
	var clamped_value = 1 if value <= 0 else value #Fija el valor en al menos 1 y deja libre para que no haya limite de número mayor para la vida ¿Esta variable es infinitamente creciente su valor o solo depende del value?
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health = value
		max_healt_changed.emit(difference) #Esto envia una señal con el valor de la diferencia 
	
		if health > max_health:
			health = max_health

func get_max_health() -> int:
	#Esta funcion devuelve en int la vida maxima determinada 
	return max_health

func set_inmortality(value: bool):
	inmportality = value

func get_inmortality() -> bool:
	return inmportality

func set_temporary_inmportality(timer: float):
	if inmportality_timer == null:
		inmportality_timer = Timer.new()
		inmportality_timer.one_shot = true
		add_child(inmportality_timer)
	
	if inmportality_timer.timeout.is_connected(set_inmortality):
		inmportality_timer.timeout.disconnect(set_inmortality) #Esto lo que hace es desconectar la inmortalidad cuando el tiempo se termina
	
	inmportality_timer.timer.set_wait_time(timer) 
	#Hasta aca crea el temporizador de inmortalidad y establese el tiempo
	inmportality_timer.timeout.connect(set_inmortality.bind(false)) #Conecta la señal de tiempo de espera a la función de configuración de inmortalidad
	inmportality = true #Este parametro se modifica cuando el tiempo termina y se establece el parametro de la linea de arriba
	inmportality_timer.start()

func set_health(value: int):
	if value < health and inmportality:
		return
	
	var clamped_value = clampi(value, 0, max_health) #Clampi es un metodo que sirve para fijar que una variable no baje de un minimo ni supere un max determinado
	
	if clamped_value != health:
		var difference = clamped_value - health
		health = value
		health_changed.emit(difference)
		
		if health == 0:
			dead.emit()

#			if state_machine:
#				state_machine.change_state(
#				state_machine.dead_state)


func get_health():
	return health #Nota para mi: Esto hace que la funcion debuleva modificaciones solo sobre la variable health

#Con estas funciones hago en el script lo mismo que hice con el @export arriba, dejo las dos formas de modificarlo disponibles (Inspector/Script)
