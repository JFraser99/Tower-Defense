extends Node


@onready var path = preload("res://stage_1.tscn")

func _on_timer_timeout():
	var tempPath = path.instantiate()
	add_child(tempPath)
