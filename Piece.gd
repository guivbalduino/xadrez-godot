extends Node2D
class_name Piece

# Enum para os tipos de peças
enum PieceType { PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING }
# Enum para as cores
enum PieceColor { WHITE, BLACK }

@export var type: PieceType
@export var color: PieceColor
@export var position_on_board: Vector2i

const SQUARE_SIZE = 80 
const BASE_PATH = "res://assets/chess_pieces/"

# Mapeia tipo e cor da peça para o caminho do arquivo da textura
var PIECE_TEXTURE_PATHS = {
	PieceColor.WHITE: {
		PieceType.PAWN: BASE_PATH + "w_pawn_png_shadow_128px.png",
		PieceType.ROOK: BASE_PATH + "w_rook_png_shadow_128px.png",
		PieceType.KNIGHT: BASE_PATH + "w_knight_png_shadow_128px.png",
		PieceType.BISHOP: BASE_PATH + "w_bishop_png_shadow_128px.png",
		PieceType.QUEEN: BASE_PATH + "w_queen_png_shadow_128px.png",
		PieceType.KING: BASE_PATH + "w_king_png_shadow_128px.png",
	},
	PieceColor.BLACK: {
		PieceType.PAWN: BASE_PATH + "b_pawn_png_shadow_128px.png",
		PieceType.ROOK: BASE_PATH + "b_rook_png_shadow_128px.png",
		PieceType.KNIGHT: BASE_PATH + "b_knight_png_shadow_128px.png",
		PieceType.BISHOP: BASE_PATH + "b_bishop_png_shadow_128px.png",
		PieceType.QUEEN: BASE_PATH + "b_queen_png_shadow_128px.png",
		PieceType.KING: BASE_PATH + "b_king_png_shadow_128px.png",
	},
}

@onready var check_border = $CheckBorder

# Função para configurar a peça
func setup(p_type: PieceType, p_color: PieceColor, p_pos: Vector2i):
	self.type = p_type
	self.color = p_color
	self.position_on_board = p_pos
	
	# Define a posição visual da peça com base em sua posição no tabuleiro
	# A posição é no centro do quadrado
	self.position = Vector2(p_pos) * SQUARE_SIZE + Vector2(SQUARE_SIZE / 2, SQUARE_SIZE / 2)
	
	_set_texture() # Define a textura correta
	_setup_border() # Desenha a borda

func _set_texture():
	var texture_path = PIECE_TEXTURE_PATHS[color][type]
	var texture = load(texture_path)
	if texture:
		$Sprite2D.texture = texture
		# Redimensiona o sprite para caber no quadrado, se necessário
		$Sprite2D.scale = Vector2(SQUARE_SIZE, SQUARE_SIZE) / texture.get_size()
	else:
		print("Erro: Não foi possível carregar a textura para ", color, " ", type, " em ", texture_path)

func _setup_border():
	var half_size = SQUARE_SIZE / 2.0
	check_border.clear_points()
	check_border.add_point(Vector2(-half_size, -half_size))
	check_border.add_point(Vector2(half_size, -half_size))
	check_border.add_point(Vector2(half_size, half_size))
	check_border.add_point(Vector2(-half_size, half_size))
	check_border.closed = true

func set_check_border(should_be_visible: bool):
	check_border.visible = should_be_visible
