extends Panel

@onready var isMinimised: bool = false
@onready var panelRect: Rect2 = get_rect()
var offset = 10
var selectedTower = null

func _process(_delta):
	var towerPath = get_tree().get_root().get_node("Main/Towers")
	var tempSelTower = null
	for i in towerPath.get_child_count():
		if towerPath.get_child(i).isSelected:
			tempSelTower = towerPath.get_child(i)
			
	selectedTower = tempSelTower
	
	if selectedTower:
		$TowerUI.hide()
		$UpgradeUI.show()
		$UpgradeUI/DEBUG.text = selectedTower.name
	else:
		$TowerUI.show()
		$UpgradeUI.hide()

func _on_button_pressed():
	if isMinimised:
		global_position = Vector2(global_position.x - panelRect.size.x + offset, global_position.y)
		$Button.text = ">"
	else:
		global_position = Vector2(global_position.x + panelRect.size.x - offset, global_position.y)
		$Button.text = "<"
	isMinimised = !isMinimised
