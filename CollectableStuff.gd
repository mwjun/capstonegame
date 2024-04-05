extends Node3D

@onready var visual : Node3D = $VisualNode

# Called when the node enters the scene tree for the first time.
var rotateSpeed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visual.rotate_y(rotateSpeed * delta)
