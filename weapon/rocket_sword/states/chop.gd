extends TorsoPartialState


@export var RELEASES_PRIORITY : float

const ANIMATION_SPEED = 1.5
const START_ANGLE: float = -60 
const END_ANGLE: float = 60
const ATTACK_RANGE: float = 10
const NARROW_CONE_WIDTH: float = 30.0

var hit_targets: Array[EnemyEntity] = []
var debug_mesh: MeshInstance3D

@onready var hit_damage = 10 # will be a function of player stats in the future


# this strange construction is here because our animation asset has a long tail transitioning to idle,
# think of it as of "custom perfect blending" to idle
# so after a certain point we want to release priority, but to anything except idle
func default_lifecycle(input : InputPackage) -> String:
	#if works_less_than(RELEASES_PRIORITY):
	if works_less_than(DURATION):
		return "okay"
	
	return best_input_that_can_be_paid(input)

func process_input_vector(input : InputPackage, delta : float):
	var progress = get_progress() / DURATION
	
	# Interpolate the exact angle of the blade on this frame
	var current_sword_angle = lerp(START_ANGLE, END_ANGLE, progress)
	
	# Rotate the player's forward vectorby that calculated angle
	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	# Move in the directin relative to the camera
	direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	var current_sword_direction = direction.rotated(Vector3.UP, deg_to_rad(current_sword_angle))
	# --- DRAW DEBUG LINE ---
	_draw_debug_line(current_sword_direction)
	
	# Query targets in range
	var targets = get_tree().get_nodes_in_group("Enemy")
	var current_position = model.area_awareness.global_position

	for target in targets:
		if target is not EnemyEntity or target in hit_targets: 
			continue
			
		var to_target = target.global_position - current_position
		
		# Performance optimization: Use squared distance check first
		var distance_squared = to_target.length_squared()
		if distance_squared <= (ATTACK_RANGE * ATTACK_RANGE):
			
			# 5. Check if the enemy falls inside our narrow sweeping cone
			var angle_to_target = rad_to_deg(current_sword_direction.angle_to(to_target))
			if angle_to_target <= (NARROW_CONE_WIDTH / 2.0):
				# Enemy is hit! Add them to the blacklist for this specific swing
				hit_targets.append(target)
				print("@@@ HIT @@@")
				#if target.has_method("take_damage"):
					#target.take_damage(damage)


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	hit.is_parryable = is_parryable()
	hit.weapon = model.character.model.active_weapon
	return hit


func on_enter_state():
	_setup_debug_mesh()
	hit_targets.clear()
	DURATION = model.states.data_repo.get_duration(backend_animation) / ANIMATION_SPEED
	model.animator.set_speed_scale(ANIMATION_SPEED, "torso")


func on_exit_state():
	debug_mesh.queue_free()
	DURATION = model.states.data_repo.get_duration(backend_animation) * ANIMATION_SPEED
	model.animator.set_speed_scale(1, "toso")
	model.character.model.active_weapon.hitbox_ignore_list.clear()
	model.character.model.active_weapon.is_attacking = false
	
# --- DEBUG VISUALIZATION HELPER METHODS ---

func _setup_debug_mesh() -> void:
	debug_mesh = MeshInstance3D.new()
	debug_mesh.mesh = ImmediateMesh.new()
	
	# Create a simple neon red material that ignores lighting
	var mat = ORMMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1, 0, 0) # Solid red line
	
	debug_mesh.material_override = mat
	model.character.add_child(debug_mesh)

func _draw_debug_line(direction: Vector3) -> void:
	if not debug_mesh: return
	var imm_mesh: ImmediateMesh = debug_mesh.mesh
	imm_mesh.clear_surfaces()
	
	imm_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	# Since the mesh is a child of model.character, Vector3.ZERO 
	# represents the exact center of your character model.
	imm_mesh.surface_add_vertex(Vector3.ZERO)
	
	# Project out locally relative to the character's space
	var local_target = direction * ATTACK_RANGE
	imm_mesh.surface_add_vertex(local_target)
	
	imm_mesh.surface_end()
	debug_mesh.visible = true
