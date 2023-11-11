extends CharacterBody2D

@export var speed = 100
var Health = 10
@onready var healthBar = $ProgressBar

func _ready():
	healthBar.max_value = Health
	healthBar.min_value = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + (speed * delta))
	
	if get_parent().get_progress_ratio() == 1:
		Game.Health -= 1
		queue_free()
		
	if Health <= 0:
		get_parent().get_parent().queue_free()
