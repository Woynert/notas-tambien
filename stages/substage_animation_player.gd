extends AnimationPlayer
class_name SubstageAnimationPlayer

@export var substage_index = -1


func _ready():
	animation_finished.connect(_on_animation_finished)
	

func _on_animation_finished(_ani: StringName):
	var stage_manager = StageManager.get_singleton()
	if !stage_manager:
		printerr("E: No stage manager")
		get_tree().quit(1)
	stage_manager.substage_finished(substage_index)
