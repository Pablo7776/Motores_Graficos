extends Control

signal iniciar

@onready var main_buttons    : VBoxContainer = $MainButtons
@onready var opciones        : Panel         = $Opciones
@onready var master_slider   : HSlider       = $Opciones/CenterContainer/VBox/RowMaster/MasterSlider
@onready var music_slider    : HSlider       = $Opciones/CenterContainer/VBox/RowMusic/MusicSlider
@onready var sfx_slider      : HSlider       = $Opciones/CenterContainer/VBox/RowSFX/SFXSlider
@onready var fullscreen_check: CheckButton   = $Opciones/CenterContainer/VBox/RowFullscreen/FullscreenCheck
@onready var label_master_val: Label         = $Opciones/CenterContainer/VBox/RowMaster/LabelMasterVal
@onready var label_music_val : Label         = $Opciones/CenterContainer/VBox/RowMusic/LabelMusicVal
@onready var label_sfx_val   : Label         = $Opciones/CenterContainer/VBox/RowSFX/LabelSFXVal


func _ready():
	main_buttons.visible = true
	opciones.visible = false
	_load_settings()

#Botones del menú

func _on_iniciar_pressed() -> void:
	iniciar.emit()
	get_tree().change_scene_to_file("res://juego/main.tscn")

func _on_ajustes_pressed() -> void:
	main_buttons.visible = false
	opciones.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_volver_pressed() -> void:
	main_buttons.visible = true
	opciones.visible = false


#Sliders de audio

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	label_master_val.text = str(int(value * 100)) + "%"
	_save_settings()

func _on_music_slider_value_changed(value: float) -> void:
	MusicManager.set_volume(value)
	label_music_val.text = str(int(value * 100)) + "%"
	_save_settings()

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	label_sfx_val.text = str(int(value * 100)) + "%"
	_save_settings()


#Pantalla completa

func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	_save_settings()


# Guarda o carga os valores para recordarki

func _save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master",      master_slider.value)
	config.set_value("audio", "music",       music_slider.value)
	config.set_value("audio", "music_muted", music_slider.value <= 0.0)
	config.set_value("audio", "sfx",         sfx_slider.value)
	config.set_value("video", "fullscreen",  fullscreen_check.button_pressed)
	config.save("user://settings.cfg")


func _load_settings():
	var config = ConfigFile.new()
	var master_vol := 1.0
	var music_vol  := 0.8
	var sfx_vol    := 1.0
	var fullscreen := false

	if config.load("user://settings.cfg") == OK:
		master_vol = config.get_value("audio", "master",     1.0)
		music_vol  = config.get_value("audio", "music",      0.8)
		sfx_vol    = config.get_value("audio", "sfx",        1.0)
		fullscreen = config.get_value("video", "fullscreen", false)

	master_slider.set_value_no_signal(master_vol)
	music_slider.set_value_no_signal(music_vol)
	sfx_slider.set_value_no_signal(sfx_vol)
	fullscreen_check.set_pressed_no_signal(fullscreen)

	label_master_val.text = str(int(master_vol * 100)) + "%"
	label_music_val.text  = str(int(music_vol  * 100)) + "%"
	label_sfx_val.text    = str(int(sfx_vol    * 100)) + "%"

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_vol))
	MusicManager.set_volume(music_vol)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),    linear_to_db(sfx_vol))

	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
