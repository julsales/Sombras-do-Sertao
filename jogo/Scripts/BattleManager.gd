extends Node

var battle_timer
var enemy_slot

func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	enemy_slot = $"../CardSlots/EnemyCardSlot"

func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	$"../UI/EndTurnButton".disabled = true
	$"../UI/EndTurnButton".visible = false

	# Compra uma carta se ainda tiver no deck
	if $"../EnemyDeck".enemy_deck.size() != 0:
		$"../EnemyDeck".draw_card()
		battle_timer.start()
		await battle_timer.timeout

	var enemy_hand = $"../EnemyHand".enemy_hand
	var card_db = preload("res://Scripts/DB/CardsDB.gd")

	# Verifica se o slot do inimigo está vazio
	if enemy_slot.get_child_count() == 0 and enemy_hand.size() > 0:
		var current_card_with_highest_atk = enemy_hand[0]
		var highest_attack = card_db.CARDS[current_card_with_highest_atk.name][1]

		# Encontra a carta com maior ataque
		for card in enemy_hand:
			var card_attack = card_db.CARDS[card.name][1]
			if card_attack > highest_attack:
				current_card_with_highest_atk = card
				highest_attack = card_attack
		
		enemy_hand.erase(current_card_with_highest_atk)
		enemy_slot.add_child(current_card_with_highest_atk)

	end_opponent_turn()


func end_opponent_turn():
	$"../UI/EndTurnButton".disabled = false
	$"../UI/EndTurnButton".visible = true
