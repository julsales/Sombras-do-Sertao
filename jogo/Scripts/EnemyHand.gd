extends Node2D

# Espaço entre as cartas
var CARD_WIDTH = 180
const HAND_Y_POSITION = 300
const DEFAULT_CARD_SPEED = 0.1

var enemy_hand = []
var center_screen_x

func _ready() -> void:
	# Pega o centro da tela
	center_screen_x = get_viewport().size.x / 2

# Função para adicionar carta à mão
func add_card_to_hand(card, speed):
	if card not in enemy_hand:
		enemy_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_SPEED)

# Atualiza a posição das cartas na mão
		
func update_hand_positions(speed):
	var hand_size = enemy_hand.size()
	if hand_size == 0:
		return

	var max_width = get_viewport().size.x * 0.85  # espaço máximo (85% da tela)
	CARD_WIDTH = min(100, max_width / hand_size)  # espaçamento ajustado

	# ESCALA com base no espaçamento disponível
	var target_scale = clamp(CARD_WIDTH / 180.0, 0.3, 1.0)  # nunca menor que 50%
	
	for i in range(hand_size):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = enemy_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position, speed)

		# Escala visual
		card.scale = Vector2(target_scale, target_scale)

# Calcula a posição da carta baseado no índice
func calculate_card_position(index):
	var total_width = (enemy_hand.size() - 1) * CARD_WIDTH
	var x_offset = (center_screen_x - total_width / 2 + index * CARD_WIDTH)
	return x_offset

# Anima a carta até a nova posição
func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

# Remove uma carta da mão
func remove_card_from_hand(card):
	if card in enemy_hand:
		enemy_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_SPEED)
