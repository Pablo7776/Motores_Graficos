extends Node

@onready var fg = $Sprite2D
const TRANSPARENT := Color(0, 0, 0, 0)


func _ready() -> void:
	randomize()
	_generate_map()
	$colision.init_map()
	
	
	
func colission_normal(pos: Vector2) -> Vector2:
	return $colision.colission_normal(pos)
	
func _generate_map() -> void:
	var fg_data = fg.texture.get_image()
	
	
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	
	noise.fractal_octaves = 2
	noise.frequency = 1.0 / 180.0 
	noise.fractal_gain = 0.8 
	
	for x in range(fg_data.get_width()):
		var high = ((noise.get_noise_1d(x) + 1) * fg_data.get_height() * 0.4) + fg_data.get_height() * 0.08
		
		for y in range(high):
			fg_data.set_pixelv(Vector2(x, y), TRANSPARENT)
			
	
	#  Aplicamos la imagen modificada al Sprite2D
	fg.texture = ImageTexture.create_from_image(fg_data)
	
	
func explosion(pos_global: Vector2, radius: int) -> void:
	#  Convertimos la posición global a la posición de la imagen
	var pos_local = fg.to_local(pos_global)
	var fg_data = fg.texture.get_image()
	
	# Hacemos el agujero en la imagen
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			# Si está fuera del círculo, ignoramos
			if Vector2(x, y).length() > radius:
				continue
				
			var pixel = pos_local + Vector2(x, y)
			
			# 3. Comprobamos los límites tanto para X como para Y
			if pixel.x < 0 or pixel.y < 0 or pixel.x >= fg_data.get_width() or pixel.y >= fg_data.get_height():
				continue
				
			# Borramos el píxel
			fg_data.set_pixelv(pixel, TRANSPARENT)
			
	# FUERA DEL BUCLE: Actualizamos la textura visual una sola vez
	fg.texture = ImageTexture.create_from_image(fg_data)
	
	# Le pasamos la imagen ya agujereada al nodo de colisiones
	$colision.actualizar_imagen(fg_data)
