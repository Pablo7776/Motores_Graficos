extends Node

# Referencia al Sprite2D que está en el mapa 
@onready var fg = $"../Sprite2D" 
var imagen_terreno: Image

# Esta es la función que tu mapa llama en _ready()
func init_map() -> void:
	# donde habrá cuevas o islas flotantes, es mejor leer la imagen directamente.
	# Guardamos la imagen en memoria para que las físicas sean muy rápidas.
	imagen_terreno = fg.texture.get_image()

# Esta es la función que tu personaje está buscando
func colission_normal(pos: Vector2) -> Vector2:
	# Si la imagen aún no ha cargado, decimos que es aire
	if imagen_terreno == null:
		return Vector2.ZERO
		
	# Convertimos la posición global del mundo a la posición local del Sprite
	var local_pos = fg.to_local(pos)
	var x = int(local_pos.x)
	var y = int(local_pos.y)
	
	# Verificamos que el personaje no se haya salido de los límites de la imagen
	if x < 0 or y < 0 or x >= imagen_terreno.get_width() or y >= imagen_terreno.get_height():
		return Vector2.ZERO # Si sale del mapa, es aire
		
	# Leemos el color del píxel exacto que el personaje está pisando
	var pixel_color = imagen_terreno.get_pixel(x, y)
	
	# Si el canal Alpha (transparencia) es mayor a 0, significa que hay tierra
	if pixel_color.a > 0.1:
		return Vector2.UP # Chocaste, hay suelo aquí
	else:
		return Vector2.ZERO # puedes pasar
		
		
func actualizar_imagen(nueva_imagen: Image) -> void:
	# Actualizamos la memoria de las colisiones con el nuevo terreno agujereado
	imagen_terreno = nueva_imagen
