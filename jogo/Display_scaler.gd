extends Node

const BASE_WIDTH: int = 1920
const BASE_HEIGHT: int = 1080

func _ready():
	scale_viewport_to_screen()

func scale_viewport_to_screen():
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var scale_x: float = float(screen_size.x) / BASE_WIDTH
	var scale_y: float = float(screen_size.y) / BASE_HEIGHT
	var scale: float = min(scale_x, scale_y)

	get_tree().root.content_scale_factor = scale
	DisplayServer.window_set_size(Vector2i(BASE_WIDTH * scale, BASE_HEIGHT * scale))
