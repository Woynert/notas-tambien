extends Node
class_name StageManager


static var _instance: StageManager
static func get_singleton() -> StageManager: # nullable
	return _instance
static func set_singleton_instance(instance: StageManager) -> int:
	if _instance != null:
		return 1
	_instance = instance
	return 0


@onready var stage_container: Node3D = $stageContainer
var stage_index: Array[String] = [
	"res://stages/stage1_class.tscn",
	"res://stages/stage2_campus.tscn",
	"res://stages/stage3_entrance.tscn",
	"res://stages/stage4_bedroom.tscn",
	"res://stages/stage5_return_campus.tscn",
	"res://stages/stage6_exam.tscn",
]

@export var initial_substage_override: int = 0
var current_stage: Stage = null
var current_stage_index: int = 0
var current_substage: int = 0
var current_substage_count: int = 0
var study_amount: int = 0


func _ready():
	if set_singleton_instance(self):
		get_tree().quit(1)
	if initial_substage_override != 0:
		current_substage = initial_substage_override
	init_stage()


func advance_stage():
	current_stage_index += 1
	current_substage = 0
	if current_stage_index >= stage_index.size():
		print("I: Game finished")
		get_tree().change_scene_to_packed(load("res://stages/main_menu/main_menu.tscn"))
		return
	init_stage()


func init_stage():
	var stage_res_path: String = stage_index[current_stage_index]
	var stage_res: PackedScene = load(stage_res_path)
	current_stage = stage_res.instantiate() as Stage
	if !current_stage:
		printerr("E: Invalid stage %s" % stage_res_path)
		get_tree().quit()
	
	for child in stage_container.get_children():
		child.queue_free()
	stage_container.add_child(current_stage)
	
	# play stage
	current_substage_count = current_stage.get_substage_count()
	print(current_stage.play_substage(current_substage))


func substage_finished(substage_index: int):
	print("Finished %d" % substage_index)
	if current_substage != substage_index:
		printerr("Finished a substage which is not the current one (current)%d != %d" % [current_substage, substage_index])
		return
	
	current_substage += 1
	if current_substage >= current_substage_count:
		print("Finished STAGE")
		advance_stage()
		return
	
	# continue with the next stage
	print(current_stage.play_substage(current_substage))


func add_to_study_amount(quantity: int):
	study_amount += quantity
	print("study_amount %s" % study_amount)
	

func skip_to_substage(substage_index: int):
	current_substage = substage_index
	print(current_stage.play_substage(current_substage))
