extends Panel


@onready var tower = preload("res://Assets/Towers/Tower_Mage.tscn")
var currTile
@onready var tempTowersPath = get_tree().get_root().get_node("Main/TempTowers")
@onready var towersPath = get_tree().get_root().get_node("Main/Towers")
var canAddAnother: bool = true

func _on_gui_input(event):
	if event is InputEventMouseMotion:
		# Left Click Down Drag
		if tempTowersPath.get_child_count() > 0:
			tempTowersPath.get_child(0).global_position = event.global_position
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.button_mask == 0 and tempTowersPath.get_child_count() > 0:
				# Left Click Up
				tempTowersPath.get_child(0).queue_free()
				
				var tempTower = tower.instantiate()
				towersPath.add_child(tempTower)
				tempTower.global_position = event.global_position
				tempTower.get_node("Area").hide()
				canAddAnother = true
			elif canAddAnother and event.button_mask == 1:
				# Left Click Down
				var tempTower = tower.instantiate()
				tempTowersPath.add_child(tempTower)
				tempTowersPath.get_child(0).global_position = event.global_position
				tempTower.process_mode = Node.PROCESS_MODE_DISABLED
				canAddAnother = false
		else:
			if tempTowersPath.get_child_count() > 0:
				tempTowersPath.get_child(0).queue_free()
				canAddAnother = true
		
