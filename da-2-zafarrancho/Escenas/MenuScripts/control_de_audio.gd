extends HSlider

func _ready():
	# Cargar volumen guardado
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var vol = config.get_value("audio", "music", 1.0)
		set_value_no_signal(vol)
		MusicManager.set_volume(vol)
	else:
		set_value_no_signal(1.0)


func _on_value_changed(value: float) -> void:
	MusicManager.set_volume(value)
	# Guardar preferencia
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("audio", "music", value)
	config.save("user://settings.cfg")
