extends StaticBody2D


var projectile = preload("res://Assets/Towers/mage_projectile.tscn")
var projDamage = 5
var pathName
var currTargets = []
var curr

func _process(_delta):
	if(!is_instance_valid(curr)):
		#self.look_at(curr.global_position)
	#else:
		for i in get_node("ProjectileContainer").get_child_count():
			get_node("ProjectileContainer").get_child(i).queue_free()

func _on_tower_body_entered(body):
	if "Enemy" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
		
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
		
		curr = currTarget
		pathName = currTarget.get_parent().name

func _on_tower_body_exited(_body):
	currTargets = get_node("Tower").get_overlapping_bodies()


func _on_timer_timeout():
	if(is_instance_valid(curr)):
		var tempProj = projectile.instantiate()
		tempProj.pathName = pathName
		tempProj.projDamage = projDamage
		get_node("ProjectileContainer").add_child(tempProj)
		tempProj.global_position = $Aim.global_position
