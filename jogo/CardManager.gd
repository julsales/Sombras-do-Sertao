extends Node2D
var screen_size
var dragging_card

const  COLLISION_MASK_CARD = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging_card:
		var mouse_pos = get_global_mouse_position()
		dragging_card.position = Vector2(clamp(mouse_pos.x,0, screen_size.x),
		clamp(mouse_pos.y,0,screen_size.y))


#Basicamente checa se o 
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Click")
			var card = card_reycast_check()
			if card:
				dragging_card = card
		else:
			print("Left Click Released")
			dragging_card = null

#Basicamente checa se o mouse ta encima da carta
func card_reycast_check():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return(result[0].collider.get_parent())
	return null
	
