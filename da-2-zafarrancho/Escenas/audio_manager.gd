extends  Node

#Sonidos del PJ base
@onready var mov_sound = $Mov
@onready var hacha_attack01 = $HachaSouds/Hacha_Attack_01
@onready var hacha_attack02 = $HachaSouds/Hacha_Attack_02
@onready var hacha_attack03 = $HachaSouds/Hacha_Attack_03
@onready var dado1 = $Salto/Dado1
@onready var dado2 = $Salto/Dado2

#Sonidos de la UI
@onready var select = $UI/Select
@onready var play = $UI/Play
@onready var end = $UI/Win
@onready var agregar_jugador = $UI/agregar_jugador

func play_hacha():
	var hacha_sounds = [ hacha_attack01, hacha_attack02, hacha_attack03 ]
	hacha_sounds.pick_random().play()

func play_dado():
	var salto_sounds = [ dado1, dado2 ]
	salto_sounds.pick_random().play()
