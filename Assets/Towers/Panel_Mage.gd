extends Panel


@onready var tower = preload("res://Assets/Towers/Tower_Mage.tscn")
var currTile
@onready var tempTowersPath = get_tree().get_root().get_node("Main/TempTowers")
@onready var towersPath = get_tree().get_root().get_node("Main/Towers")

func _on_gui_input(event):
	var tempTower = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1:
		# Left Click Down
		tempTowersPath.add_child(tempTower)
		tempTowersPath.get_child(0).global_position = event.global_position
		tempTower.process_mode = Node.PROCESS_MODE_DISABLED
	elif event is InputEventMouseMotion and event.button_mask == 1:
		# Left Click Down Drag
		tempTowersPath.get_child(0).global_position = event.global_position
	elif event is InputEventMouseButton and event.button_mask == 0:
		# Left Click Up
		tempTowersPath.get_child(0).queue_free()
		
		towersPath.add_child(tempTower)
		tempTower.global_position = event.global_position
		tempTower.get_node("DetectionArea").hide()
