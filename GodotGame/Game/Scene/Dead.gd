extends StateBase

@export var materialEffectAnimationPlayer : AnimationPlayer
@export var collisionShape3D : CollisionShape3D

func enter():
	super.enter()
	
	character.velocity = Vector3.ZERO
	collisionShape3D.disabled = true
	
	await get_tree().create_timer(1).timeout
	materialEffectAnimationPlayer.play("Dead")
	
	await get_tree().create_timer(3).timeout
	character.queue_free()
	
