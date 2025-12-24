extends Node2D

const SQUARE_SIZE = 80
const BOARD_SIZE = 8

const BASE_TILE_PATH = "res://assets/board_tiles/"
const BOARD_TILE_LIGHT_TEXTURE_PATH = BASE_TILE_PATH + "square brown light_png_shadow_128px.png"
const BOARD_TILE_DARK_TEXTURE_PATH = BASE_TILE_PATH + "square brown dark_png_shadow_128px.png"

func _ready():
	generate_board()

func generate_board():
	for x in range(BOARD_SIZE):
		for y in range(BOARD_SIZE):
			var square = Sprite2D.new() # Agora é um Sprite2D!
			
			var texture_path: String
			if (x + y) % 2 == 0:
				texture_path = BOARD_TILE_LIGHT_TEXTURE_PATH
			else:
				texture_path = BOARD_TILE_DARK_TEXTURE_PATH
			
			var texture = load(texture_path)
			if texture:
				square.texture = texture
				# Posiciona o sprite no canto superior esquerdo do quadrado
				square.position = Vector2(x * SQUARE_SIZE, y * SQUARE_SIZE)
				# Redimensiona o sprite para cobrir o SQUARE_SIZE
				square.scale = Vector2(SQUARE_SIZE, SQUARE_SIZE) / texture.get_size()
				# Ajusta o offset para que o centro do sprite esteja no centro do SQUARE_SIZE, se necessário
				# Para tiles, geralmente a posição é o canto superior esquerdo. Se o asset tem offset, aqui seria o lugar
				square.centered = false # Garante que a posição é o canto superior esquerdo
			else:
				# Caso a textura não carregue, voltamos a usar um ColorRect temporário
				var fallback_rect = ColorRect.new()
				fallback_rect.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
				fallback_rect.position = Vector2(x * SQUARE_SIZE, y * SQUARE_SIZE)
				if (x + y) % 2 == 0:
					fallback_rect.color = Color(0.9, 0.9, 0.9)
				else:
					fallback_rect.color = Color(0.4, 0.4, 0.4)
				square = fallback_rect # Usa o ColorRect como substituto
				print("Erro: Não foi possível carregar a textura do tile para a posição (", x, ",", y, ") em ", texture_path)


			
			add_child(square)
