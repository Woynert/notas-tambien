extends Area3D
class_name InteractArea

@export var substage_index = -1


func _is_playable_overlapping() -> bool:
	for body in get_overlapping_bodies():
		if body.get_parent() is Playable:
			return true
	return false


func _physics_process(delta):
	if _is_playable_overlapping():
		$Label3D.visible = true
		if Input.is_action_just_pressed("interact_e"):
			print("I: Player interacted")
			var stage_manager = StageManager.get_singleton()
			stage_manager.substage_finished(substage_index)
	else:
		$Label3D.visible = false
