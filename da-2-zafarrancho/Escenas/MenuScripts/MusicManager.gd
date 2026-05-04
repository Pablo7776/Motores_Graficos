extends Node

var musica : AudioStreamPlayer

func _ready():
	musica = AudioStreamPlayer.new()
	musica.bus = "Music"
	add_child(musica)

	var stream = load("res://Recursos/MainMenu/TestMusic.mp3")
	if stream:
		stream.loop = true
		musica.stream = stream
		_apply_saved_volume()
		musica.play()


func _apply_saved_volume():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var vol = config.get_value("audio", "music", 1.0)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Music"),
			linear_to_db(vol)
		)


func set_volume(value: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(value)
	)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value <= 0.0)
