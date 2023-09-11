extends KinematicBody2D


enum state {idle, walk, grabbed, fall, land}
var goal_position : Vector2
var goal_gap : Vector2
var mousebutton_down : bool
var velocity = Vector2()
var move_direction : Vector2
var speed = 90
const GRAVITY = 200.0
var was_on_floor : bool

onready var pet_state = state.idle
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

""""
func _process(_delta):
	
	if mousebutton_down == true:
		var grab_offset = Vector2(visual.get_rect().size.x * 1.5, visual.get_rect().size.y / 1.5)
		position = get_global_mouse_position() - grab_offset
		visual.grabbed()
		get_node("/root/Root").update_pet_area()
		pet_state = state.grabbed
	elif mousebutton_down == false:
		if (goal_position-position).length() > 20 and is_on_floor() == true:
			goal_gap = Vector2(goal_position-position)
			move_direction = goal_gap.normalized()#((goal_position-position)/10).clamped(5)
			visual.flip_h = move_direction.x > 0
			visual.walk()
			pet_state = state.walk
		elif is_on_floor() == true and pet_state != state.fall:
			visual.stop_walk()
			get_node("/root/Root").update_pet_area()
			pet_state = state.idle
		elif is_on_floor() == true and pet_state == state.fall:
			visual.set_idle
			goal_position = position
			pet_state = state.land
		elif is_on_floor() == false:
			visual.fall()
			pet_state = state.fall
"""
	
func _physics_process(delta):
	if pet_state == state.idle:
		velocity = Vector2(0, 0)
	if pet_state == state.walk:
		velocity += move_direction
	if pet_state == state.fall:
		velocity.x = 0
	if pet_state == state.grabbed:
		velocity = Vector2(0, 0)
	if pet_state == state.land:
		velocity = Vector2(0, 0)
		
	velocity.y += GRAVITY * delta
	velocity.x = velocity.normalized().x * speed
	velocity = move_and_slide(velocity, Vector2.UP)
	check_state()
	was_on_floor = is_on_floor()

func check_state():
	if mousebutton_down == true:
		var grab_offset = Vector2(visual.get_rect().size.x * 1.5, visual.get_rect().size.y / 1.5)
		position = get_global_mouse_position() - grab_offset
		visual.grabbed()
		get_node("/root/Root").update_pet_area()
		pet_state = state.grabbed
	elif mousebutton_down == false:
		if (goal_position-position).length() > 20 and was_on_floor == true:
			goal_gap = Vector2(goal_position-position)
			move_direction = goal_gap.normalized()#((goal_position-position)/10).clamped(5)
			visual.flip_h = move_direction.x > 0
			visual.walk()
			pet_state = state.walk
		elif was_on_floor == true and pet_state != state.fall:
			visual.stop_walk()
			get_node("/root/Root").update_pet_area()
			pet_state = state.idle
		elif velocity == Vector2(0, 0)  and pet_state == state.fall:
			visual.set_idle()
			goal_position = position
			pet_state = state.land
		elif was_on_floor == false:
			visual.fall()
			pet_state = state.fall

func choose_pos():
	if is_on_floor() == false:
		return
	var r = buttons.get_rect()
	goal_position = Vector2(rand_range(0, OS.window_size.x-r.size.x), OS.window_size.y-r.size.y)


func setPosition():
	var r = buttons.get_rect()
	OS.window_size = OS.get_screen_size()-Vector2(0, 1)
	position = Vector2(OS.window_size.x-r.size.x, OS.window_size.y-r.size.y)
	
