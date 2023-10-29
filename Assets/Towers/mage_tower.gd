extends StaticBody2D


var projectile = preload("res://Assets/Towers/mage_projectile.tscn")
var projDamage = 5
var pathName
var currTargets = []
var target

var canAttack: bool = true
@onready var cooldownTimer: Timer = $AttackCooldownTimer
@onready var detectionArea: Area2D = $DetectionArea

func _ready():
	cooldownTimer.wait_time = 0.6
	cooldownTimer.one_shot = true

func _process(_delta):
	if not target:
		#self.look_at(curr.global_position)
	#else:
		for i in get_node("ProjectileContainer").get_child_count():
			get_node("ProjectileContainer").get_child(i).queue_free()
			
	detectEnemies()
	
	if target and canAttack:
		attack()
		canAttack = false
		cooldownTimer.start()

func _on_tower_body_entered(body):
	if not target and "Enemy" in body.name:
		target = body.get_node("../")

func _on_tower_body_exited(_body):
	currTargets = detectionArea.get_overlapping_bodies()

func detectEnemies():
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
	var tempProj = projectile.instantiate()
	tempProj.pathName = pathName
	tempProj.projDamage = projDamage
	get_node("ProjectileContainer").add_child(tempProj)
	tempProj.global_position = $Aim.global_position

func _on_timer_timeout():
	canAttack = true
		
