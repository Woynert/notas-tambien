extends Area3D
class_name SubstageFinishArea

@export var substage_index = -1


func _ready():
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body):
	if body.get_parent() is Playable:
		var stage_manager = StageManager.get_singleton()
		stage_manager.substage_finished(substage_index)
