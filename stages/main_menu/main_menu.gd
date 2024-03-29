extends Node3D


func _ready():
	$scene/Person/LocalAnimationPlayer.play("sleep")
	$scene/Person/LocalAnimationPlayer.stop()
	%btnPlay.pressed.connect(_on_play)
	%btnQuit.pressed.connect(_on_quit)


func _on_play():
	get_tree().change_scene_to_packed(load("res://main.tscn"))


func _on_quit():
	get_tree().quit()
