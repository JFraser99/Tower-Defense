extends CharacterBody2D


var target
var speed = 400
var pathName = ""
var projDamage

func _physics_process(_delta):
	var waveControllerNode = get_tree().get_root().get_node("Main/WaveController")
	for i in waveControllerNode.get_child_count():
		if waveControllerNode.get_child(i).name == pathName:
			target = waveControllerNode.get_child(i).get_child(0).get_child(0).global_position
	
	if target:		
		velocity = global_position.direction_to(target) * speed
		look_at(target)
		move_and_slide()
	

func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
		body.Health -= projDamage
		body.healthBar.value = body.Health
		queue_free()
