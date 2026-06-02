extends CharacterBody3D

@export var health: Node3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DAMAGE_BUFFER = 1.5

@onready var camera := $SpringArmPivot/Camera3D
@onready var animation_player = $AnimationPlayer
@onready var mesh := $Barbarian

var damage_buffer_time = 0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	if health:
		health.health_depleted.connect(die)
	# Check if this specific player instance is controlled by THIS machine
	if is_multiplayer_authority():
		camera.make_current()
	else:
		# Optional: Turn off the camera entirely for other players 
		# so it doesn't waste processing power
		camera.clear_current() 
		camera.queue_free() # Or just delete it to keep the scene clean

func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Move in the directin relative to the camera
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	# Rotate mesh
	var target_angle = atan2(direction.x, direction.z)
	mesh.rotation.y = lerp_angle(mesh.rotation.y, target_angle, 0.2)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	# --- ANIMATION LOGIC ---
	# Check if we are on the floor and moving horizontally
	if is_on_floor():
		if velocity.length() > 0.2 and velocity.y == 0:
			animation_player.play("Player/Running_B")
		elif velocity.length() == 0 and animation_player.current_animation != "Player/Melee_1H_Attack_Chop":
			animation_player.play("Player/Idle_B")
			
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()

			if collider and collider.has_method("is_in_group"):
				if collider.is_in_group("enemy") and health and damage_buffer_time <= 0:
					damage_buffer_time = DAMAGE_BUFFER
					health.take_damage(collider.damage)
	
	damage_buffer_time -= delta
	move_and_slide()
	
func die() -> void:
	queue_free()
