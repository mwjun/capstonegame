
@onready var navAgent : NavigationAgent3D = $NavigationAgent3D
var player : Node3D
@onready var visual : Node3D = $SlimeBasicModel
@onready var animationPlayer : AnimationPlayer = $SlimeBasicModel/AnimationPlayer


const SPEED = 0.2
const JUMP_VELOCITY = 4.5
var direction : Vector3
var stopDistance : float = 2.2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready(): 
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta):
	
	navAgent.target_position = player.global_position
	direction = navAgent.get_next_path_position() - global_position
	direction.normalized()
	
	if navAgent.distance_to_target() < stopDistance:
		return
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	velocity = velocity.lerp(direction*SPEED, delta)
	animationPlayer.play("Attack")
	
	if velocity.length() > 0.2:
		var lookDir = Vector2(velocity.z, velocity.x)
		visual.rotation.y = lookDir.angle()
	move_and_slide()
