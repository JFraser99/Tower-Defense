extends Panel

@onready var isMinimised: bool = false
@onready var panelRect: Rect2 = get_rect()
var offset = 10

func _on_button_pressed():
	if isMinimised:
		global_position = Vector2(global_position.x - panelRect.size.x + offset, global_position.y)
	else:
		global_position = Vector2(global_position.x + panelRect.size.x - offset, global_position.y)
	isMinimised = !isMinimised
