extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = $ani1/AnimationPlayer as AnimationPlayer
	player.play("main")
	player.animation_finished.connect(_animation_finished)
	
func _animation_finished(anim: String):
	print("animation finished")
