extends Node2D
var screen_size
var dragging_card
var is_hovering_on_card
var player_hand_reference
var card_preview
const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_SPEED = 0.1

# Called when the node enters the scene tree for the first time.
#Pega o tamanho da tela do jogo
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", left_click_released)
	card_preview = $"../CardPreview"
	card_preview.visible = false
# Checa se o mouse está na carta e arrasta ela de acordo com o mouse,
# também usa o clamp pra restringir a área de onde essa carta pode ir de acordo com a posição do mouse e a posição do tamanho da tela
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging_card:
		var mouse_pos = get_global_mouse_position()
		dragging_card.position = Vector2(clamp(mouse_pos.x,0, screen_size.x),
		clamp(mouse_pos.y,0,screen_size.y))


#Checa se o click esquerdo do mouse está ativo e chama a func do raycast pra saber se está clicando em uma carta, se sim, arrasta ela
#func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#var card = card_raycast_check()
			#if card:
				#start_drag(card)
		#else:
			#if dragging_card:
				#finish_drag()
			#

func start_drag(card):
	dragging_card = card
	card.scale = Vector2(1,1)
	
func finish_drag():
	dragging_card.scale = Vector2(1.05,1.05)
	var card_slot_found = card_slot_raycast_check()
	if card_slot_found and not card_slot_found.card_in_slot:
		#Carta foi colocada em um card slot vazio
		player_hand_reference.remove_card_from_hand(dragging_card)
		dragging_card.position = card_slot_found.position
		dragging_card.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = true
	else:
		player_hand_reference.add_card_to_hand(dragging_card, DEFAULT_CARD_SPEED)
		
	dragging_card = null

#conecta os sinais mandados por card.gd pra esse script, melhor para garantir que todas as cartas vão funcionar da mesma forma
func connect_card_signals(card):
	card.connect("hovered", hover_over_card)
	card.connect("hovered_off", hover_off_card)
	
func left_click_released():
	print("funciono")
	if dragging_card:
		finish_drag()
	
func hover_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)
	

func hover_off_card(card):
	if !dragging_card:
		var hover_new_card = card_raycast_check()
		if hover_new_card:
			highlight_card(hover_new_card, true)
		else:
			is_hovering_on_card = false
			highlight_card(card,false)
	
func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05,1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1,1)
		card.z_index = 1
		
#Checa se a posição do mouse está na da posição do slot e retorna o id específico do slot
func card_slot_raycast_check():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters) 
	if result.size() > 0:
		return(result[0].collider.get_parent())
	return null
	
#Checa se a posição do mouse está na da posição da carta e retorna o id específico da carta
func card_raycast_check():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters) 
	if result.size() > 0:
		#return(result[0].collider.get_parent())
		return card_highest_z_index(result)
	return null
	
func card_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1,cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
