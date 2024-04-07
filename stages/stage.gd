extends Node3D
class_name Stage

@onready var substages_root: Node3D = $substages
@export var substage_list: Array[bool] = []
var current_substage_node: Node3D = null


func _ready():
	_disable_all_stages()


func _disable_all_stages():
	for stage in substages_root.get_children():
		_disable_recursive(stage)
		if stage is Node3D: stage.visible = false
		
		# hide top level control nodes
		for child in stage.get_children():
			if child is Control: child.visible = false


func _disable_recursive(node: Node):
	node.set_process(false)
	node.set_physics_process(false)
	for child in node.get_children():
		_disable_recursive(child)


func _enable_stage(stage: Node):
	# show top level control nodes
	for child in stage.get_children():
		if child is Control: child.visible = true
	
	stage.visible = true
	_enable_recursive(current_substage_node)


func _enable_recursive(node: Node):
	node.set_process(true)
	node.set_physics_process(true)
	for child in node.get_children():
		_enable_recursive(child)


func get_substage_count() -> int:
	return substage_list.size()


func play_substage(substage_index: int) -> int:
	# end previous substage
	if current_substage_node != null:
		var playable = current_substage_node.get_node_or_null("player") as Playable
		if playable: # only if is_gameplay
			playable.end()
	_disable_all_stages()
	
	# start requested substage
	if substage_index >= substage_list.size():
		return 1
	
	current_substage_node = substages_root.get_node("%d" % substage_index)
	if !current_substage_node:
		return 2
	
	_enable_stage(current_substage_node)
	
	# true  -> gameplay
	# false -> animation
	var is_gameplay = substage_list[substage_index]
	if is_gameplay:
		var playable = current_substage_node.get_node("player") as Playable
		if !playable:
			return 3
		playable.start()
	
	else:
		var ani_player = current_substage_node.get_node("AnimationPlayer") as AnimationPlayer
		if !ani_player:
			return 4
		if !ani_player.has_animation("main"):
			return 5
		ani_player.play("main")

	return 0


func properly_end_substage(substage_index: int) -> int:
	if substage_index >= substage_list.size():
		return 1
	
	var substage = substages_root.get_node("%d" % substage_index)
	if !substage:
		return 2
	
	_disable_all_stages()
	substage.visible = true
	_enable_recursive(substage)
	
	# true  -> gameplay
	# false -> animation
	var is_gameplay = substage_list[substage_index]
	if is_gameplay:
		var playable = substage.get_node("player") as Playable
		if !playable:
			return 3
		playable.start()
	
	else:
		var ani_player = substage.get_node("AnimationPlayer") as AnimationPlayer
		if !ani_player:
			return 4
		if !ani_player.has_animation("main"):
			return 5
		ani_player.play("main")
	
	return 0
