extends StateBase
#export variables, variable name: from the corresponding Node
@export var hitBoxShape : CollisionShape3D
@export var hitAnimation : AnimationPlayer
@export var VFX_Blade : Node3D
@export var VFX_Hit : GPUParticles3D
@export var nextAttackState : String



#damage percentage
var  damage : int = 40
var slideSpeed: float = 500
var remainSlideDuration: float
var facingDir: Vector3
var can_attack_again: bool

func enableHitBox():
	hitBoxShape.disabled = false
	print("hit box enabled")
	
func disableHitBox():
	hitBoxShape.disabled = true
	print("hit box disabled")
	
func enter():
	super.enter()
	can_attack_again = false
	character.velocity.x = 0 
	character.velocity.z = 0
	
	VFX_Blade.visible = true
	hitAnimation.stop()
	hitAnimation.play("PlayerBladeVFX")
	
	#sliding while attacking
	remainSlideDuration = animationPlayer.current_animation_length * 0.2
	
	
func exit():
	super.exit()
	disableHitBox()
	VFX_Blade.visible = false
	
func state_update(_delta:float):
	
	remainSlideDuration -= _delta
	#change the facing direction of the visual node
	facingDir = character.visual.transform.basis.z
	
	#if character hits the target, it will reduce velocity to 0
	#this stops the character more naturally than setting velocity 
	#hard coded to 0
	
	if remainSlideDuration > 0:
		character.velocity.x = facingDir.x * slideSpeed * _delta
		character.velocity.z = facingDir.z * slideSpeed * _delta
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, character.SPEED)
		character.velocity.z = move_toward(character.velocity.z, 0 ,character.SPEED)
	
	if animationPlayer.is_playing()==false:
		state_machine.switchTo("Idle")
			
			#if these conditions are not met, it will not be able to 
			#go to the next attack state to do attack combos
	if nextAttackState != '' && can_attack_again && character.attackKey_pressed:
		state_machine.switchTo(nextAttackState)
		

func _on_hit_box_body_entered(body):
	if body.is_in_group("Enemy"):
		body.applyDamage(damage)
		
		var position = body.global_position
		position.y = 1.5
		VFX_Hit.global_position = position
		VFX_Hit.restart()
		remainSlideDuration = 0
		
func set_canAttackAgain():
	can_attack_again = true
