extends Node2D

#Path das card scene
#Espaço entre as cartas
var CARD_WIDTH = 180  # valor inicial padrão
const HAND_Y_POSITION = 900
const DEFAULT_CARD_SPEED = 0.1
var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Pega o centro da tela
	center_screen_x = get_viewport().size.x / 2
	

#função pra adicionar cartas a mão
func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_SPEED)
#Pega a posicao da carta baseado no index de quantas cartas existem em uma mão
func update_hand_positions(speed):
	var hand_size = player_hand.size()
	if hand_size == 0:
		return

	var max_width = get_viewport().size.x * 0.85  # espaço máximo (85% da tela)
	CARD_WIDTH = min(180, max_width / hand_size)  # espaçamento ajustado

	# ESCALA com base no espaçamento disponível
	var target_scale = clamp(CARD_WIDTH / 180.0, 0.5, 1.0)  # nunca menor que 50%
	
	for i in range(hand_size):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position, speed)

		# Escala visual
		card.scale = Vector2(target_scale, target_scale)
	
func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = (center_screen_x - total_width / 2 + index * CARD_WIDTH)
	return x_offset
	
func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_SPEED)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
