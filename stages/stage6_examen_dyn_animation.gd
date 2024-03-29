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
		player_ani_student.play("examen-result-bad")
		player_voice.stream = load("res://resources/sfx/voices/st-9.ogg")
		player_voice.play()
	# play sleep
	elif score == 101:
		print("play sleep")
		player_ani_student.play("examen-result-bad")
		player_voice.stream = load("res://resources/sfx/voices/st-9.ogg")
		player_voice.play()
	# play study
	elif score == 11:
		print("play study")
		player_ani_student.play("examen-result-neutral")
		player_voice.stream = load("res://resources/sfx/voices/st-11.ogg")
		player_voice.play()
	# study study
	elif score == 20:
		print("study study")
		player_ani_student.play("examen-result-neutral")
		player_voice.stream = load("res://resources/sfx/voices/st-12.ogg")
		player_voice.play()
	# study sleep
	elif score == 110:
		print("study sleep")
		player_ani_student.play("examen-result-good")
		player_voice.stream = load("res://resources/sfx/voices/st-13.ogg")
		player_voice.play()
	else:
		printerr("Caso no soportado %s" % score)
		get_tree().quit()
