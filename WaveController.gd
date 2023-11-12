extends Node

var WaveData = preload("res://WaveData.gd")

var currentWaveIndex : int = -1
var waveTimer : Timer = Timer.new()
var spawnTimer : Timer = Timer.new()
var waves : Array = []

@onready var path = preload("res://stage_1.tscn")

signal wave_completed(wave_index)

func _ready():
	add_child(waveTimer)
	add_child(spawnTimer)
	spawnTimer.connect("timeout", Callable(self, "spawn_enemy"))
	waveTimer.connect("timeout", Callable(self, "on_wave_timer_timeout"))
	spawnTimer.autostart = false
	waveTimer.autostart = false
	setup_waves()
	#start_next_wave()
	
func setup_waves():
	waves.append(WaveData.new(5, preload("res://Assets/Enemy/Enemy.tscn"), 1.0))
	waves.append(WaveData.new(20, preload("res://Assets/Enemy/Enemy.tscn"), 0.3))
	
func start_next_wave():
	currentWaveIndex += 1
	if currentWaveIndex >= waves.size():
		print("All Waves Completed")
		return
	
	var wave = waves[currentWaveIndex]
	spawnTimer.wait_time = wave.spawnInterval
	spawnTimer.one_shot = true
	spawnTimer.start()
	waveTimer.wait_time = wave.spawnInterval * wave.enemyCount
	waveTimer.one_shot = true
	waveTimer.start()
	
func spawn_enemy():
	if currentWaveIndex < waves.size():
		var wave = waves[currentWaveIndex]
		if wave:
			var tempPath = path.instantiate()
			add_child(tempPath)
			
			var enemyInstance = wave.enemyScene.instantiate()
			tempPath.get_child(0).add_child(enemyInstance)
			
			wave.enemyCount -= 1
			if wave.enemyCount > 0:
				spawnTimer.start()
			
func on_wave_timer_timeout():
	emit_signal("wave_completed", currentWaveIndex)
	#currentWaveIndex += 1
	#start_next_wave()

#@onready var path = preload("res://stage_1.tscn")

#func _on_timer_timeout():
#	var tempPath = path.instantiate()
#	add_child(tempPath)
