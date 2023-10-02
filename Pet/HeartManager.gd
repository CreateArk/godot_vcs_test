extends Node2D

var heart_count
onready var HeartTimer = $HeartTimer
onready var Pet = $Pet
onready var save_file = SaveFile.game_data


func _on_HeartTimer_timeout():
	save_file.HeartCount += 1
	print_debug(save_file.HeartCount)
	SaveFile.save_data()
