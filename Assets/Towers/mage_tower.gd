extends "res://Assets/Towers/BaseTower.gd"

var mage_projectile = preload("res://Assets/Towers/mage_projectile.tscn")
var mage_damage = 5

func _ready():
	damage = mage_damage
	super._ready()  # Correct way to call the parent class's _ready function

	# MageTower-specific _ready logic can go here if needed

func get_attack_cooldown():
	return 0.6  # MageTower specific cooldown

func attack():
	var tempProj = mage_projectile.instantiate()
	tempProj.pathName = pathName
	tempProj.projDamage = mage_damage
	projectileContainer.add_child(tempProj)
	tempProj.global_position = $Aim.global_position
	# No need to call ._attack() here unless the base class has implementation for it that you want to use
