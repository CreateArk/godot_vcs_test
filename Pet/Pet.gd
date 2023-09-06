extends KinematicBody2D
# This is the pet itself
# You can make as many as you'd like in theory and this can be anything you like.
# As long as everything you want on screen is in the Cutout group and overwrites
# get_cutout_polygon() or is a Control, Path2D or Sprite. Those 3 have automatic
# polygons assinged if they don't overwrite get_cutout_polygon()

var goal_position : Vector2
var mousebutton_down : bool
var velocity = Vector2()
const GRAVITY = 200.0

onready var visual := $PetVisuals
onready var buttons := $Buttons

func _ready():
	randomize()
	setPosition()
	choose_pos()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mousebutton_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mousebutton_down = false


func _process(_delta):
	
#	if (goal_position-position).length() > 20 && mousebutton_down == false:
#		var dir := ((goal_position-position)/10).clamped(5)
#		position += dir
#		visual.flip_h = dir.x > 0
#		visual.walk()
#		get_node("/root/Root").update_pet_area()
#	elif mousebutton_down == false && is_on_floor() == true:
#		visual.stop_walk()
	if mousebutton_down == false && is_on_floor() == false:
		visual.fall()
	elif mousebutton_down == true:
		var grab_offset = Vector2(visual.get_rect().size.x * 1.5, visual.get_rect().size.y / 1.5)
		position = get_global_mouse_position() - grab_offset
		velocity = Vector2(0, 0)
		visual.grabbed()
	
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func choose_pos():
	var r = buttons.get_rect()
	goal_position = Vector2(rand_range(0, OS.window_size.x-r.size.x), OS.window_size.y-r.size.y)


func setPosition():
	var r = buttons.get_rect()
	OS.window_size = OS.get_screen_size()-Vector2(0, 1)
	position = Vector2(OS.window_size.x-r.size.x, OS.window_size.y-r.size.y)
	
