extends Node2D

const PieceScene = preload("res://Piece.tscn")
const PieceScript = preload("res://Piece.gd")
const SQUARE_SIZE = 80
const BOARD_SIZE = 8

@onready var pieces_node = $Pieces
@onready var status_label = $StatusLabel
@onready var move_highlights_node = $MoveHighlights
@onready var turn_indicator = $TurnIndicator

var selected_piece = null
var current_turn = PieceScript.PieceColor.WHITE
var board_state = []
var white_king_pos: Vector2i
var black_king_pos: Vector2i
var game_over = false

func _ready():
	# Centraliza a label dinamicamente e a esconde
	var screen_center = get_viewport_rect().size / 2
	status_label.position = screen_center - status_label.size / 2
	status_label.visible = false
	
	setup_board()
	update_check_status() # Garante que o estado inicial de xeque (nenhum) seja refletido
	update_turn_indicator() # Define a cor inicial do indicador de turno

#================================================
# Input Handling
#================================================

func _unhandled_input(event):
	if game_over: return # Não permite input se o jogo acabou
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var board_pos = screen_to_board(event.position)
		handle_click(board_pos)

func handle_click(board_pos):
	if not is_valid_board_pos(board_pos):
		deselect_piece()
		return

	if selected_piece == null:
		var piece = get_piece_at(board_pos)
		if piece != null and piece.color == current_turn:
			select_piece(piece)
	else:
		var from_pos = selected_piece.position_on_board
		var to_pos = board_pos

		if from_pos == to_pos:
			deselect_piece()
			return
			
		var target_piece = get_piece_at(to_pos)
		if target_piece != null and target_piece.color == selected_piece.color:
			deselect_piece()
			select_piece(target_piece)
			return

		if is_move_fully_legal(selected_piece, from_pos, to_pos):
			var original_target = get_piece_at(to_pos)
			commit_move(selected_piece, from_pos, to_pos, original_target)
			change_turn()
		
		deselect_piece()

#================================================
# Board and Piece Logic
#================================================

func setup_board():
	game_over = false # Reseta o estado do jogo
	for child in pieces_node.get_children():
		child.queue_free()

	board_state.resize(BOARD_SIZE)
	for x in range(BOARD_SIZE):
		board_state[x] = []
		board_state[x].resize(BOARD_SIZE)
		for y in range(BOARD_SIZE):
			board_state[x][y] = null

	# Peças Pretas
	create_piece(PieceScript.PieceType.ROOK, PieceScript.PieceColor.BLACK, Vector2i(0, 0))
	create_piece(PieceScript.PieceType.KNIGHT, PieceScript.PieceColor.BLACK, Vector2i(1, 0))
	create_piece(PieceScript.PieceType.BISHOP, PieceScript.PieceColor.BLACK, Vector2i(2, 0))
	create_piece(PieceScript.PieceType.QUEEN, PieceScript.PieceColor.BLACK, Vector2i(3, 0))
	create_piece(PieceScript.PieceType.KING, PieceScript.PieceColor.BLACK, Vector2i(4, 0))
	create_piece(PieceScript.PieceType.BISHOP, PieceScript.PieceColor.BLACK, Vector2i(5, 0))
	create_piece(PieceScript.PieceType.KNIGHT, PieceScript.PieceColor.BLACK, Vector2i(6, 0))
	create_piece(PieceScript.PieceType.ROOK, PieceScript.PieceColor.BLACK, Vector2i(7, 0))
	for i in range(8):
		create_piece(PieceScript.PieceType.PAWN, PieceScript.PieceColor.BLACK, Vector2i(i, 1))

	# Peças Brancas
	create_piece(PieceScript.PieceType.ROOK, PieceScript.PieceColor.WHITE, Vector2i(0, 7))
	create_piece(PieceScript.PieceType.KNIGHT, PieceScript.PieceColor.WHITE, Vector2i(1, 7))
	create_piece(PieceScript.PieceType.BISHOP, PieceScript.PieceColor.WHITE, Vector2i(2, 7))
	create_piece(PieceScript.PieceType.QUEEN, PieceScript.PieceColor.WHITE, Vector2i(3, 7))
	create_piece(PieceScript.PieceType.KING, PieceScript.PieceColor.WHITE, Vector2i(4, 7))
	create_piece(PieceScript.PieceType.BISHOP, PieceScript.PieceColor.WHITE, Vector2i(5, 7))
	create_piece(PieceScript.PieceType.KNIGHT, PieceScript.PieceColor.WHITE, Vector2i(6, 7))
	create_piece(PieceScript.PieceType.ROOK, PieceScript.PieceColor.WHITE, Vector2i(7, 7))
	for i in range(8):
		create_piece(PieceScript.PieceType.PAWN, PieceScript.PieceColor.WHITE, Vector2i(i, 6))

func create_piece(type: PieceScript.PieceType, color: PieceScript.PieceColor, pos: Vector2i):
	var piece_instance = PieceScene.instantiate()
	pieces_node.add_child(piece_instance)
	piece_instance.setup(type, color, pos)
	board_state[pos.x][pos.y] = piece_instance
	if type == PieceScript.PieceType.KING:
		set_king_pos(color, pos)

func get_piece_at(board_pos: Vector2i):
	if is_valid_board_pos(board_pos):
		return board_state[board_pos.x][board_pos.y]
	return null

func select_piece(piece: Piece):
	selected_piece = piece
	selected_piece.scale = Vector2(1.2, 1.2)
	selected_piece.z_index = 10
	show_possible_moves(piece)

func deselect_piece():
	if selected_piece != null:
		selected_piece.scale = Vector2(1.0, 1.0)
		selected_piece.z_index = 0
		selected_piece = null
	clear_move_highlights()

func commit_move(piece, from_pos: Vector2i, to_pos: Vector2i, captured_piece_node):
	if captured_piece_node != null:
		capture_piece(captured_piece_node)

	# Atualiza board_state ANTES de mover a peça
	board_state[from_pos.x][from_pos.y] = null
	board_state[to_pos.x][to_pos.y] = piece
	
	# Atualiza a posição do rei, se ele foi movido
	if piece.type == PieceScript.PieceType.KING:
		set_king_pos(piece.color, to_pos)

	# Atualiza a posição lógica e visual da peça
	piece.position_on_board = to_pos
	piece.position = Vector2(to_pos) * SQUARE_SIZE + Vector2(SQUARE_SIZE / 2, SQUARE_SIZE / 2)

func capture_piece(piece_node):
	piece_node.queue_free()

func change_turn():
	current_turn = PieceScript.PieceColor.BLACK if current_turn == PieceScript.PieceColor.WHITE else PieceScript.PieceColor.WHITE
	
	update_check_status() # Atualiza o status de xeque e borda para o novo jogador
	update_turn_indicator() # Atualiza a cor do indicador de turno
	
	if is_checkmate(current_turn):
		game_over = true
		status_label.text = "XEQUE-MATE!"
		status_label.modulate.a = 1.0
		status_label.visible = true
		print("XEQUE-MATE! Jogo acabou.")
	elif is_king_in_check(current_turn):
		show_check_animation()

#================================================
# UI and Highlights
#================================================

func show_possible_moves(piece: Piece):
	clear_move_highlights()
	var from_pos = piece.position_on_board
	for x in range(BOARD_SIZE):
		for y in range(BOARD_SIZE):
			var to_pos = Vector2i(x, y)
			if is_move_fully_legal(piece, from_pos, to_pos):
				var highlight = ColorRect.new()
				highlight.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
				highlight.position = Vector2(to_pos.x * SQUARE_SIZE, to_pos.y * SQUARE_SIZE)
				highlight.color = Color(0, 1, 0, 0.3) # Verde semi-transparente
				highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
				move_highlights_node.add_child(highlight)

func clear_move_highlights():
	for child in move_highlights_node.get_children():
		child.queue_free()

func show_check_animation():
	status_label.text = "XEQUE!"
	status_label.modulate.a = 1.0 # Garante que a opacidade está no máximo
	status_label.visible = true
	
	var tween = create_tween()
	# Espera 1 segundo, depois anima o fade out por 0.5 segundos
	tween.tween_interval(1.0)
	tween.tween_property(status_label, "modulate:a", 0.0, 0.5)
	# Esconde a label quando a animação terminar
	tween.tween_callback(func(): status_label.visible = false)

func update_turn_indicator():
	if current_turn == PieceScript.PieceColor.WHITE:
		turn_indicator.color = Color(0.9, 0.9, 0.9) # Um cinza claro para não ser tão forte
	else:
		turn_indicator.color = Color(0.2, 0.2, 0.2) # Um cinza escuro

#================================================
# Move Validation Logic
#================================================

func is_move_fully_legal(piece: Piece, from_pos: Vector2i, to_pos: Vector2i) -> bool:
	if not is_move_pseudo_legal(piece, from_pos, to_pos):
		return false

	# Simula o movimento para verificar se deixa o próprio rei em xeque
	var original_target = get_piece_at(to_pos)
	board_state[to_pos.x][to_pos.y] = piece
	board_state[from_pos.x][from_pos.y] = null
	var king_pos_backup = get_king_pos(piece.color)
	if piece.type == PieceScript.PieceType.KING:
		set_king_pos(piece.color, to_pos)

	var is_legal = not is_king_in_check(piece.color)

	# Desfaz a simulação
	board_state[from_pos.x][from_pos.y] = piece
	board_state[to_pos.x][to_pos.y] = original_target
	set_king_pos(piece.color, king_pos_backup)

	return is_legal

func is_move_pseudo_legal(piece, from_pos: Vector2i, to_pos: Vector2i) -> bool:
	if not is_valid_board_pos(to_pos): return false
	var target_piece = get_piece_at(to_pos)
	if target_piece != null and target_piece.color == piece.color: return false

	match piece.type:
		PieceScript.PieceType.PAWN: return is_pawn_move_valid(piece, from_pos, to_pos)
		PieceScript.PieceType.ROOK: return is_rook_move_valid(from_pos, to_pos)
		PieceScript.PieceType.BISHOP: return is_bishop_move_valid(from_pos, to_pos)
		PieceScript.PieceType.KNIGHT: return is_knight_move_valid(from_pos, to_pos)
		PieceScript.PieceType.QUEEN: return is_queen_move_valid(from_pos, to_pos)
		PieceScript.PieceType.KING: return is_king_move_valid(from_pos, to_pos)
	return false

func is_pawn_move_valid(pawn_piece, from_pos: Vector2i, to_pos: Vector2i) -> bool:
	var dx = to_pos.x - from_pos.x; var dy = to_pos.y - from_pos.y
	var forward_dir = -1 if pawn_piece.color == PieceScript.PieceColor.WHITE else 1
	if dx == 0:
		if dy == forward_dir and get_piece_at(to_pos) == null: return true
		if dy == 2 * forward_dir and (from_pos.y == 6 or from_pos.y == 1) and get_piece_at(to_pos) == null and get_piece_at(from_pos + Vector2i(0, forward_dir)) == null: return true
	if abs(dx) == 1 and dy == forward_dir and get_piece_at(to_pos) != null and get_piece_at(to_pos).color != pawn_piece.color: return true
	return false

func is_rook_move_valid(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	return (from_pos.x == to_pos.x or from_pos.y == to_pos.y) and is_path_clear(from_pos, to_pos)

func is_bishop_move_valid(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	return abs(from_pos.x - to_pos.x) == abs(from_pos.y - to_pos.y) and is_path_clear(from_pos, to_pos)

func is_knight_move_valid(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	var dx = abs(from_pos.x - to_pos.x); var dy = abs(from_pos.y - to_pos.y)
	return (dx == 1 and dy == 2) or (dx == 2 and dy == 1)

func is_queen_move_valid(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	return (from_pos.x == to_pos.x or from_pos.y == to_pos.y or abs(from_pos.x - to_pos.x) == abs(from_pos.y - to_pos.y)) and is_path_clear(from_pos, to_pos)

func is_king_move_valid(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	return abs(from_pos.x - to_pos.x) <= 1 and abs(from_pos.y - to_pos.y) <= 1

#================================================
# Check/Checkmate Logic
#================================================

func update_check_status():
	var white_king_node = get_piece_at(white_king_pos)
	var black_king_node = get_piece_at(black_king_pos)

	if white_king_node:
		white_king_node.set_check_border(is_king_in_check(PieceScript.PieceColor.WHITE))
	if black_king_node:
		black_king_node.set_check_border(is_king_in_check(PieceScript.PieceColor.BLACK))
	
	# Animação de texto só para o jogador da vez
	if is_king_in_check(current_turn) and not is_checkmate(current_turn):
		show_check_animation()
	else:
		status_label.visible = false # Esconde a label se não está em xeque

func is_square_under_attack(square_pos: Vector2i, attacker_color: PieceScript.PieceColor) -> bool:
	for x in range(BOARD_SIZE):
		for y in range(BOARD_SIZE):
			var piece = board_state[x][y]
			if piece != null and piece.color == attacker_color:
				if piece.type == PieceScript.PieceType.PAWN:
					var dy = square_pos.y - piece.position_on_board.y
					var dx = abs(square_pos.x - piece.position_on_board.x)
					var forward_dir = -1 if piece.color == PieceScript.PieceColor.WHITE else 1
					if dx == 1 and dy == forward_dir: return true
				elif is_move_pseudo_legal(piece, piece.position_on_board, square_pos):
					return true
	return false

func is_king_in_check(king_color: PieceScript.PieceColor) -> bool:
	var king_pos = get_king_pos(king_color)
	var attacker_color = PieceScript.PieceColor.BLACK if king_color == PieceScript.PieceColor.WHITE else PieceScript.PieceColor.WHITE
	return is_square_under_attack(king_pos, attacker_color)

#================================================
# Checkmate Logic
#================================================

func is_checkmate(king_color: PieceScript.PieceColor) -> bool:
	if not is_king_in_check(king_color):
		return false # Não é xeque-mate se o rei não está em xeque
	
	# Tenta encontrar qualquer movimento legal que tire o rei do xeque
	for x in range(BOARD_SIZE):
		for y in range(BOARD_SIZE):
			var piece_to_move = board_state[x][y]
			if piece_to_move != null and piece_to_move.color == king_color:
				for target_x in range(BOARD_SIZE):
					for target_y in range(BOARD_SIZE):
						var to_pos = Vector2i(target_x, target_y)
						if is_move_fully_legal(piece_to_move, piece_to_move.position_on_board, to_pos):
							return false # Encontrou um movimento legal, então não é xeque-mate
	
	return true # Nenhum movimento legal encontrado para sair do xeque

#================================================
# Helper Functions
#================================================

func get_king_pos(color: PieceScript.PieceColor) -> Vector2i:
	return white_king_pos if color == PieceScript.PieceColor.WHITE else black_king_pos

func set_king_pos(color: PieceScript.PieceColor, pos: Vector2i):
	if color == PieceScript.PieceColor.WHITE:
		white_king_pos = pos
	else:
		black_king_pos = pos

func screen_to_board(screen_pos: Vector2) -> Vector2i:
	var board_x = floor(screen_pos.x / SQUARE_SIZE); var board_y = floor(screen_pos.y / SQUARE_SIZE)
	return Vector2i(board_x, board_y)

func is_valid_board_pos(board_pos: Vector2i) -> bool:
	return board_pos.x >= 0 and board_pos.x < BOARD_SIZE and board_pos.y >= 0 and board_pos.y < BOARD_SIZE

func is_path_clear(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	var direction = (to_pos - from_pos).sign()
	var current_pos = from_pos + direction
	while current_pos != to_pos:
		if get_piece_at(current_pos) != null: return false
		current_pos += direction
	return true
