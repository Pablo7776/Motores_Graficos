extends TileMapLayer

#VARIABLES DE GENERACIÓN 
@export var ancho_mundo: int = 100
@export var alto_mundo: int = 60
@export var id_tierra: int = 0
@export var ancho_dibujo_tiles: int = 80
@export var alto_dibujo_tiles: int = 8

# VARIABLES DE DESTRUCCIÓN ---
@export var radio_explosion_pixels: float = 48.0

var generador_ruido = FastNoiseLite.new()

func _ready():
	randomize()
	generar_isla()

# FUNCIÓN DE GENERACIÓN PROCEDIMENTAL
func generar_isla():
	generador_ruido.seed = randi()
	generador_ruido.noise_type = FastNoiseLite.TYPE_SIMPLEX
	generador_ruido.frequency = 0.05
	
	for x in range(ancho_mundo):
		var valor_ruido = generador_ruido.get_noise_1d(x)
		var altura_superficie = int(valor_ruido * 10) + 30
		
		for y in range(altura_superficie, alto_mundo):
			var atlas_x = x % ancho_dibujo_tiles
			var atlas_y = y % alto_dibujo_tiles
			var coordenada_dinamica = Vector2i(atlas_x, atlas_y)
			
			# Al quitar "terreno.", el script se modifica a sí mismo directamente
			set_cell(Vector2i(x, y), id_tierra, coordenada_dinamica)

func crear_crater(posicion_global_explosion: Vector2):
	var pos_local = to_local(posicion_global_explosion)
	var celda_centro = local_to_map(pos_local)
	
	var tamaño_tile = tile_set.tile_size.x
	var radio_en_celdas = int(radio_explosion_pixels / tamaño_tile)
	
	var celdas_modificadas: Array[Vector2i] = []
	
	for x in range(-radio_en_celdas, radio_en_celdas + 1):
		for y in range(-radio_en_celdas, radio_en_celdas + 1):
			var celda_actual = celda_centro + Vector2i(x, y)
			var distancia = Vector2(celda_centro).distance_to(Vector2(celda_actual))
			
			if distancia <= radio_en_celdas:
				erase_cell(celda_actual)
				celdas_modificadas.append(celda_actual)
