extends Playable


@onready var player_voice: AudioStreamPlayer = $"../../../aniShared/PlayerMainVoice"
@onready var player_ani_student: AnimationPlayer = $"../../../aniShared/student/LocalAnimationPlayer"


func start():
	var stage_manager = StageManager.get_singleton()
	var score = stage_manager.study_amount
	
	print("Analyzing score")
	# play play
	if score == 2: 
		print("play play")
		player_ani_student.play("examen-play-play")
		player_voice.stream = load("res://resources/sfx/voices/st-3.ogg")
		player_voice.play()
	# play sleep
	elif score == 101:
		print("play sleep")
		player_ani_student.play("examen-play-sleep")
		player_voice.stream = load("res://resources/sfx/voices/st-4.ogg")
		player_voice.play()
	# play study
	elif score == 11:
		print("play study")
		player_ani_student.play("examen-play-study")
		player_voice.stream = load("res://resources/sfx/voices/st-5.ogg")
		player_voice.play()
	# study study
	elif score == 20:
		print("study study")
		player_ani_student.play("examen-play-study")
		player_voice.stream = load("res://resources/sfx/voices/st-6.ogg")
		player_voice.play()
	# study sleep
	elif score == 110:
		print("study sleep")
		player_ani_student.play("examen-study-sleep")
		player_voice.stream = load("res://resources/sfx/voices/st-7.ogg")
		player_voice.play()
	else:
		printerr("Caso no soportado %s" % score)
		get_tree().quit()


func _on_animation_finished():
	var stage_manager = StageManager.get_singleton()
	var score = stage_manager.study_amount

	# skip the substage where the player is sleeping
	if score >= 100:
		stage_manager.skip_to_substage(4)
