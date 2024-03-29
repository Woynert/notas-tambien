extends Playable

@export var substage_index = -1
@export var skip_substages: bool = false
@export var show_sleep: bool = false
enum ACTION {
	PLAY,
	STUDY,
	SLEEP
}


func _ready():
	if !show_sleep:
		%Sep2.visible = false
		%BtnSleep.visible = false

	(%BtnPlay as Button).pressed.connect(func(): _on_button_pressed(ACTION.PLAY))
	%BtnStudy.pressed.connect(func(): _on_button_pressed(ACTION.STUDY))
	%BtnSleep.pressed.connect(func(): _on_button_pressed(ACTION.SLEEP))


func _on_button_pressed(action: ACTION):
	print ("Actions selected %s" % action)
	%BtnPlay.disabled = true
	%BtnStudy.disabled = true
	%BtnSleep.disabled = true
	
	var stage_manager = StageManager.get_singleton()
	if !stage_manager:
		printerr("Can't find stage_manager")
		get_tree().quit(1)
	
	match action:
		ACTION.PLAY:
			stage_manager.add_to_study_amount(1)
			if skip_substages: stage_manager.skip_to_substage(6)
		ACTION.STUDY:
			stage_manager.add_to_study_amount(10)
			if skip_substages: stage_manager.skip_to_substage(6)
		ACTION.SLEEP:
			stage_manager.add_to_study_amount(100)
			if skip_substages: stage_manager.substage_finished(substage_index)
	
	if skip_substages: 
		return
	stage_manager.substage_finished(substage_index)


func start():
	print("They called me")
	$Camera3D.make_current()
