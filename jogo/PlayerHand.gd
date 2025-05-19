extends Node2D

#Com quantas cartas começa
const HAND_COUNT = 6
#Path das card scene
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
#Espaço entre as cartas
const CARD_WIDTH = 200
const HAND_Y_POSITION = 750
var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Pega o centro da tela
	center_screen_x = get_viewport().size.x / 2
	
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range (HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name="Card"
		add_card_to_hand(new_card)

#função pra adicionar cartas a mão
func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)
#Pega a posicao da carta baseado no index de quantas cartas existem em uma mão
func update_hand_positions():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)
	
func calculate_card_position(index):
	var total_width = (player_hand.size() -1 ) * CARD_WIDTH
	var x_offset = center_screen_x - total_width / 2 + index * CARD_WIDTH
	return x_offset
	
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
