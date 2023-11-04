extends Panel


@onready var tower = preload("res://Assets/Towers/Tower_Mage.tscn")
var currTile
#@onready var tempTowersPath = get_tree().get_root().get_node("Main/TempTowers")
@onready var towersPath = get_tree().get_root().get_node("Main/Towers")
var canAddAnother: bool = true
var overlappingTower: bool = false

func _process(_delta):
	if get_child_count() > 1:
		get_child(1).global_position = get_global_mouse_position()
		
		if not overlappingTower:
			var mapPath = get_tree().get_root().get_node("Main/TileMap")
			var tile = mapPath.local_to_map(get_global_mouse_position())		
			currTile = mapPath.get_cell_atlas_coords(0, tile, false)
			if currTile == Vector2i(0,0):
				get_child(1).get_node("Area").modulate = Color(0,0,0,0.6)
			else:
				get_child(1).get_node("Area").modulate = Color(255,0,0,0.6)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if get_child_count() > 1 and currTile == Vector2i(0,0) and not overlappingTower:
			get_child(1).queue_free()
				
			var tempTower = tower.instantiate()
			towersPath.add_child(tempTower)
			tempTower.global_position = event.global_position
			tempTower.get_node("Area").hide()
			tempTower.placingTower = false
			canAddAnother = true

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if canAddAnother and event.button_mask == 1:
				# Left Click Down
				var tempTower = tower.instantiate()
				add_child(tempTower)
				get_child(1).global_position = event.global_position
				tempTower.process_mode = Node.PROCESS_MODE_DISABLED
				tempTower.scale = Vector2(0.5,0.5)
				canAddAnother = false
		else:
			if get_child_count() > 1:
				get_child(1).queue_free()
				canAddAnother = true
		
