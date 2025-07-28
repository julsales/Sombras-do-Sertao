extends Node2D

##Path das card scene
#const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
#var player_deck = ["Card","Card"]
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func draw_card():
	#print("draw")
	#var card_drawn = player_deck[0]
	#player_deck.erase(card_drawn)
	#
	#if player_deck.size()==0:
		#$Area2D/CollisionShape2D.disabled = true
		#$Sprite2D.visible = false
	#
	#var card_scene = preload(CARD_SCENE_PATH)
	#var new_card = card_scene.instantiate()
	#$"../CardManager".add_child(new_card)
	#new_card.name="Card"
	#$"../PlayerHand".add_card_to_hand(new_card)

const CARD_SCENE_PATH = "res://Scenes/EnemyCard.tscn"
const CARD_DRAW_SPEED = 0.3
const STARTING_HAND_SIZE = 5

var enemy_deck = ["Perna Cabeluda", "Perna Cabeluda", "Perna Cabeluda", "Perna Cabeluda", "Perna Cabeluda"]
var card_db

func _ready() -> void:
	enemy_deck.shuffle()
	card_db = preload("res://Scripts/DB/CardsDB.gd")
	initial_draw(STARTING_HAND_SIZE)
	$DeckCounter.text = str(enemy_deck.size())

func initial_draw(count: int):
	for i in range(count):
		if enemy_deck.size() > 0:
			draw_card()

func draw_card():
	var card_drawn = enemy_deck[0]
	enemy_deck.erase(card_drawn)

	if enemy_deck.size() == 0:
		$Sprite2D.visible = false
		$DeckCounter.visible = false

	$DeckCounter.text = str(enemy_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = "res://Assets/Images/Cards/" + card_drawn + ".png"
	var card_back_image_path

	if card_db.CARDS[card_drawn][3] == true:
		card_back_image_path = "res://Assets/Images/Card Back/Verso Carta Sombra.png"
	else:
		card_back_image_path = "res://Assets/Images/Card Back/Verso Carta Luz.png"

	new_card.get_node("CardBack").texture = load(card_back_image_path)
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Points").text = str(card_db.CARDS[card_drawn][1])
	new_card.get_node("Desc").text = str(card_db.CARDS[card_drawn][2])
	new_card.card_type = card_db.CARDS[card_drawn][3]

	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../EnemyHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
