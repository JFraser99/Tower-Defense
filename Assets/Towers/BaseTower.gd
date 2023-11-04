extends StaticBody2D

# Default properties for a Tower
var damage = 1
var target = null
var canAttack: bool = true
var currTargets = []
var pathName
var placingTower = null

@onready var cooldownTimer: Timer = $AttackCooldownTimer
@onready var detectionArea: Area2D = $DetectionArea
@onready var projectileContainer = $ProjectileContainer  # Make sure you have this node in your scene

func _ready():
	cooldownTimer.wait_time = get_attack_cooldown()  # Define get_attack_cooldown in derived classes
	cooldownTimer.one_shot = true
	connect_signals()

func connect_signals():
	detectionArea.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detectionArea.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	cooldownTimer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	set_process_input(true)

func _process(_delta):
	#if not target:
		#self.look_at(curr.global_position)
	#else:
		#for i in get_node("ProjectileContainer").get_child_count():
			#get_node("ProjectileContainer").get_child(i).queue_free()
			
	detect_targets()
	
	if target and canAttack:
		attack()
		canAttack = false
		cooldownTimer.start()

func get_attack_cooldown() -> float:
	return 1.0  # Default cooldown, override in subclasses if necessary

func detect_targets():
	var tempArray = []
	currTargets = detectionArea.get_overlapping_bodies()
	
	for i in currTargets:
		if "Enemy" in i.name:
			tempArray.append(i)
			
	var currTarget = null
	
	for i in tempArray:
		if currTarget == null:
			currTarget = i.get_node("../")
		else:
			if i.get_parent().get_progress() > currTarget.get_progress():
				currTarget = i.get_node("../")
	
	target = currTarget
	if target:
		pathName = currTarget.get_parent().name

func attack():
	# Generic attack function
	pass

func _on_Timer_timeout():
	canAttack = true
	
func _on_detection_area_body_entered(body):
	if not target and "Enemy" in body.name:  # Make sure this condition fits how you determine if a body is an enemy
		target = body.get_node("../")

func _on_detection_area_body_exited(_body):
	currTargets = detectionArea.get_overlapping_bodies()

func _on_input_event(_viewport, event, _shape_idx):
	if not placingTower:
		if event is InputEventMouseButton and event.button_mask == 1:
			var towerPath = get_tree().get_root().get_node("Main/Towers")
			for i in towerPath.get_child_count():
				if towerPath.get_child(i).name != self.name:
					towerPath.get_child(i).get_node("Upgrade/Upgrade").hide()
			var upgradeNode = get_node("Upgrade/Upgrade")
			upgradeNode.visible = !upgradeNode.visible
			upgradeNode.global_position = self.position + Vector2(-upgradeNode.size.x / 2, upgradeNode.size.y / 3)

func _on_mouse_entered():
	var placingTowerUINode = get_tree().get_root().get_node("Main/UI/Panel/FlowContainer")
	var nodeCount = placingTowerUINode.get_child_count()
	for i in nodeCount:
		if not placingTower:
			var panel = placingTowerUINode.get_child(i)
			if panel and panel.get_child_count() > 1:
				placingTower = panel
				
	if placingTower:
		if placingTower.get_child_count() <= 1:
			placingTower = null
		else:
			placingTower.overlappingTower = true
			placingTower.get_child(1).get_node("Area").modulate = Color(255,0,0,0.6)
		
func _on_mouse_exited():
	if placingTower:
		placingTower.overlappingTower = false
		if placingTower.get_child_count() <= 1:
			placingTower = null
		else:
			placingTower.get_child(1).get_node("Area").modulate = Color(0,0,0,0.6)
