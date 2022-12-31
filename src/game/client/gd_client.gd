extends CharacterBody3D
class_name Character

@export var camera:SpringArm3D

@export var client_ground_speed = 12
@export var client_ground_friction = 0.9
@export var client_air_friction = 0.9
@export var client_gravity = -16
@export var client_jump_force = 5

enum CLIENT_STATES {
	IDLE,
	MOVING,
	JUMPING,
	FALLING
}

enum ROTATION_METHOD {
	FREE,
	LOCKED
}

var current_rotation_method = ROTATION_METHOD.FREE
var current_client_state = CLIENT_STATES.IDLE

func _ready():
	camera.camera_state_changed.connect(_on_camera_state_change)
func _physics_process(delta):
	var input_direction:Vector2 = Vector2(Input.get_axis("client_move_left", "client_move_right"), Input.get_axis("client_move_fowards", "client_move_backwards"))
	
	var direction = Vector3(
		(camera.transform.basis.z.x * input_direction.y) + camera.transform.basis.x.x * input_direction.x, 
		0, 
		(camera.transform.basis.z.z * input_direction.y) + camera.transform.basis.x.z * input_direction.x
		)
	
	match current_rotation_method:
		ROTATION_METHOD.FREE:
			if input_direction.length() > 0:
				rotation.y = lerp_angle(rotation.y, camera.rotation.y + atan2(input_direction.x, input_direction.y), 0.25)
		ROTATION_METHOD.LOCKED:
			rotation.y = camera.rotation.y
	
	match current_client_state:
		CLIENT_STATES.IDLE:
			
			apply_friction(client_ground_friction)
			
			if input_direction.length() > 0:
				current_client_state = CLIENT_STATES.MOVING
	
			if !is_on_floor():
				current_client_state = CLIENT_STATES.FALLING
				
			if Input.is_action_just_pressed("client_action_jump"):
				jump()
		CLIENT_STATES.MOVING:
			apply_movement(direction, client_ground_speed, delta)
			apply_friction(client_ground_friction)
			
			move_and_slide()
			
			if input_direction.length() == 0:
				current_client_state = CLIENT_STATES.IDLE
				
			if !is_on_floor():
				current_client_state = CLIENT_STATES.FALLING

			if Input.is_action_just_pressed("client_action_jump"):
				jump()
				
		CLIENT_STATES.FALLING:
			velocity.y += client_gravity * delta
			apply_friction(client_air_friction)
			apply_movement(direction, client_ground_speed, delta)
			move_and_slide()
			
			if is_on_floor():
				velocity.y = 0
				current_client_state = CLIENT_STATES.MOVING
				
		CLIENT_STATES.JUMPING:
			velocity.y += client_gravity * delta
			apply_friction(client_air_friction)
			apply_movement(direction, client_ground_speed, delta)
			move_and_slide()
			
			if velocity.y < 0:
				current_client_state = CLIENT_STATES.FALLING

func jump():
	velocity.y += client_jump_force
	current_client_state = CLIENT_STATES.JUMPING

func apply_movement(direction:Vector3, speed:float, delta:float):
	velocity += direction.normalized() * speed * delta
	move_and_slide()

func apply_friction(friction):
	velocity.x *= friction
	velocity.z *= friction
	
	move_and_slide()

func _on_camera_state_change(cur, old):
	if cur > 1:
		current_rotation_method = ROTATION_METHOD.LOCKED
	else: current_rotation_method = ROTATION_METHOD.FREE
