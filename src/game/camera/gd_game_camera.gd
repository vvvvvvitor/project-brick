extends SpringArm3D
class_name GameCamera

@export var sensitivity = 0.01
@export var max_zoom:float = 35
@export var min_zoom:float = 0 
@export @onready var target:Node3D
@onready var camera = get_viewport().get_camera_3d()

enum CAMERA_STATES {
	IDLE, # 0
	MOVING, # 1
	LOCKED, # 2
	FIRST_PERSON # 3
}

signal camera_state_changed
var last_camera_state
var current_camera_state = CAMERA_STATES.IDLE:
	get: return current_camera_state
	set(val):
		last_camera_state = current_camera_state
		emit_signal("camera_state_changed", val, current_camera_state)
		current_camera_state = val

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _input(event):
	if current_camera_state != CAMERA_STATES.IDLE:
		if event is InputEventMouseMotion:
			move_camera(event.relative * sensitivity)
			
	if event is InputEvent:
		if event.is_action_pressed("action_zoom_in"):
			spring_length -= 2
			spring_length = clamp(spring_length, min_zoom, max_zoom)
		if event.is_action_pressed("action_zoom_out"):
			spring_length += 2
			spring_length = clamp(spring_length, min_zoom, max_zoom)

func _process(delta):
	global_position = target.global_position
	
	camera.rotation.x = -CoreUiManager.pause_menu.custom_minimum_size.y / (camera.fov * 8)
	
	match current_camera_state:
		CAMERA_STATES.IDLE:
			CursorManager.current_cursor_state = CursorManager.CURSOR_STATES.HAND_OPEN
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			if Input.is_action_just_pressed("action_lock_camera"):
				current_camera_state = CAMERA_STATES.LOCKED
	
			if spring_length == 0:
				current_camera_state = CAMERA_STATES.FIRST_PERSON
		
			if Input.is_action_pressed("action_move_camera"):
				current_camera_state = CAMERA_STATES.MOVING
				
		CAMERA_STATES.MOVING:
			CursorManager.current_cursor_state = CursorManager.CURSOR_STATES.HAND_CLOSED
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			if Input.is_action_just_pressed("action_lock_camera"):
				current_camera_state = CAMERA_STATES.LOCKED
				
			if spring_length == 0:
				current_camera_state = CAMERA_STATES.FIRST_PERSON
			
			if Input.is_action_just_released("action_move_camera"):
				current_camera_state = CAMERA_STATES.IDLE
				
		CAMERA_STATES.LOCKED:
			camera.h_offset = 1
			
			if spring_length == 0:
				current_camera_state = CAMERA_STATES.FIRST_PERSON
			
			CursorManager.current_cursor_state = CursorManager.CURSOR_STATES.AIM
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
			if Input.is_action_just_pressed("action_lock_camera") && spring_length > 0:
				current_camera_state = CAMERA_STATES.IDLE
				camera.h_offset = 0
				
		CAMERA_STATES.FIRST_PERSON:
			camera.h_offset = 0
			
			CursorManager.current_cursor_state = CursorManager.CURSOR_STATES.AIM
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
			if spring_length > 0:
				current_camera_state = last_camera_state

func move_camera(amount:Vector2) -> void:
	rotation.x -= amount.y
	rotation.y -= amount.x
	rotation.x = clamp(rotation.x, -PI / 2.1, PI / 2.1)
