class_name WaveData

var enemyCount : int
var enemyScene : PackedScene
var spawnInterval : float

func _init(count : int, scene : PackedScene, interval : float):
	enemyCount = count
	enemyScene = scene
	spawnInterval = interval
