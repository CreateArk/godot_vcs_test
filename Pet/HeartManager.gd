extends Node2D

onready var SpawnTimeMin = 5
onready var SpawnTimeMax = 10
onready var HeartScene = load("res://Heart/Heart.tscn")
onready var PetScene = get_node("/root/Root/Pet")

func _ready():
	randomize()
	SpawnHeart()

func SpawnHeart():
	var SpawnTime = rand_range(SpawnTimeMin, SpawnTimeMax)
	yield(get_tree().create_timer(SpawnTime),"timeout")
	var Heart = HeartScene.instance()
	Heart.set_position(PetScene.position)
	add_child(Heart)
	SpawnHeart()
