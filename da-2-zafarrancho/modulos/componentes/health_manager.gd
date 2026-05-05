class_name HealthManager extends Area2D
##Gestiona todo lo vinculado a la vida de su padre, incluso cuando es eliminado. 

var max_hp;
var current_hp;

signal impacto_recibido(hp:int)
signal defeat

func _ready() -> void:
	 #Le pide al nodo padre que le pase su variable MAX_HP, si esta variable no existe, falla
	max_hp = get_parent().MAX_HP
	current_hp = max_hp
	impacto_recibido.emit(current_hp); #claramente necesita otro nombre, lo usamos para actualizar ui solamente
	if get_parent() is PersonajeBase: #VER si es necesario este condicional 
		#defeat.connect(GestorDeTurnos.enemigo_eliminado) Queda por sumar en el gestor de turnos PARA SACARLO DE PANTALLA
		pass

func check_death():
	if current_hp <= 0:
		defeat.emit()
		get_parent().queue_free();

func take_damage(dmg: int):
	current_hp -= dmg;
	impacto_recibido.emit(current_hp);
	check_death();

"""
signal max_healt_changed(diff: int)
signal health_changed(diff: int) # Es una herramienta o funcionalidad utilizada para comparar para identificar exactamente qué ha cambiado entre ellos. Ejem: Vida = 100 → 80 → diff = -20
signal dead

signal impacto_recibido(hp:int) #Esto sunmamos para probar 

@export var max_health: int : set = set_max_health, get = get_max_health
#De esta forma exporto la variable como parametro modificable mediante el inspector y lo modifico como nodo hijo desde la escena del PJ a quien se lo instancie 
@export var inmortality: bool = false : set = set_inmortality, get = get_inmortality
#Con esta variable le doy un x tiempo de inmortalidad al PJ cuando aparece (No creo que sea necesariio en el juego pero lo dejo pinchado para probar), haciendolo bool lo transformo en un parametro de on/off en el inspector

var inmortality_timer: Timer = null #El timer para contar los segundo de importalidad en el momento del spawn 

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
	inmortality = value

func get_inmortality() -> bool:
	return inmortality

func set_temporary_inmortality(timer: float):
	if inmortality_timer == null:
		inmortality_timer = Timer.new()
		inmortality_timer.one_shot = true
		add_child(inmortality_timer)
	
	if inmortality_timer.timeout.is_connected(set_inmortality):
		inmortality_timer.timeout.disconnect(set_inmortality) #Esto lo que hace es desconectar la inmortalidad cuando el tiempo se termina
	
	inmortality_timer.timer.set_wait_time(timer) 
	#Hasta aca crea el temporizador de inmortalidad y establese el tiempo
	inmortality_timer.timeout.connect(set_inmortality.bind(false)) #Conecta la señal de tiempo de espera a la función de configuración de inmortalidad
	inmortality = true #Este parametro se modifica cuando el tiempo termina y se establece el parametro de la linea de arriba
	inmortality_timer.start()

func set_health(value: int):
	if value < health and inmortality:
		return
	
	var clamped_value = clampi(value, 0, max_health) #Clampi es un metodo que sirve para fijar que una variable no baje de un minimo ni supere un max determinado
	
	if clamped_value != health:
		var difference = clamped_value - health
		health = value
		health_changed.emit(difference)
		
		if health == 0:
			dead.emit()


func get_health():
	return health #Nota para mi: Esto hace que la funcion debuleva modificaciones solo sobre la variable health

#Con estas funciones hago en el script lo mismo que hice con el @export arriba, dejo las dos formas de modificarlo disponibles (Inspector/Script)
"""
