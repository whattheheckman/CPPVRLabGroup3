extends Node




@export var levers_needed := 3
var current_levers = 0

var in_reactor : bool = false
var game_ended  : bool = false
var doomsday_started : bool = false

@export var robot : PackedScene
@export var robotlocations : PackedVector3Array
@export var robotrotation : PackedFloat32Array

@export var levers_Sound : AudioStreamPlayer
@export var core_destruct_sound : AudioStreamPlayer

@onready var reactormusic = $"Music/Reactor Music"
@onready var angrymusic = $"Music/Angry Music"
@onready var happymusic = $"Music/Happy Music"
@onready var creditsmusic = $"Music/Credits Music"

@onready var radio_extraction = $Radio/ExtractionDialogue

@onready var exploded_text : MeshInstance3D = $"../XR_Player/XRCamera3D/exploded text"
@onready var accomplished_text : MeshInstance3D = $"../Safezone/Mission Accomplished"

@onready var countdown = $Countdown
@export var animationPlayer : AnimationPlayer 


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Safezone/Mission Accomplished".set_visible(false)
	exploded_text.set_visible(false)
	pass # Replace with function body.

func pulllever():
	
	if (current_levers == levers_needed - 1):
		doomsday()
	else:
		current_levers += 1;
		levers_Sound.play()
	
	
func doomsday():
	doomsday_started = true
	happymusic.stop()
	reactormusic.stop()
	angrymusic.play()
	await get_tree().create_timer(2.0).timeout
	countdown.start()
	$"../CoreNorminal".stop()
	animationPlayer.play("Doomsday")
	#core_destruct_sound.play() controlled by animation
	
	var four_count : Array = [robotlocations[0], robotlocations[1],robotlocations[2],robotlocations[3]]
	for location in four_count:
		var new_robot = robot.instantiate()

		new_robot.set_global_position(location)
		get_tree().root.add_child(new_robot)
		new_robot.health = 10 #FIXME: not picking up the health field for somereason, probably bc it's a scene
	
	

	
	

##func _process(delta):
##	countdown_label.text = countdown.time_left
## TODO: implement countdown timer


func _on_safezone_body_entered(_body):
	print(str(_body))
	while not countdown.is_stopped() and doomsday_started and game_ended == false:
		game_ended = true
		# FIXME: you can't win wtf
		win()



func _on_reactor_dialogue_trigger_body_entered(_body):
	print("RECEIEVE REACTOR SIGNAL")
	if  in_reactor == false:
		happymusic.stop()
		reactormusic.play()
		in_reactor = true
	
@onready var tween_out = get_tree().create_tween()
var transition_duration = 2.50
var transition_type = 1 # TRANS_SINE
var last_stream_faded : AudioStreamPlayer
var last_vol : float

func fade_out(stream_player : AudioStreamPlayer):
	# tween music volume down to 0
	last_stream_faded = stream_player
	last_vol = stream_player.volume_db
	tween_out.interpolate_property(stream_player, "volume_db", last_vol, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	# when the tween ends, the music will be stopped

func _on_TweenOut_tween_completed(object, _key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
	last_stream_faded.volume_db = last_vol
	
	


func _on_countdown_timeout():
	if game_ended == false:
		lose()
	pass


func win():
	game_ended = true
	accomplished_text.set_visible(true)
	accomplished_text.mesh.set_text(accomplished_text.mesh.get_text() + " \n You had " + str(countdown.time_left) + " seconds left")
	accomplished_text.mesh.set_text(accomplished_text.mesh.get_text() + " \n Thank you for playing :)")
	countdown.queue_free()
	angrymusic.stop()
	happymusic.stop()
	reactormusic.stop()
	$"../CoreExplodeSound".stop()
	core_destruct_sound.stop()
	creditsmusic.play()
	pass





func lose():
	game_ended = true
	angrymusic.stop()
	happymusic.stop()
	reactormusic.stop()

	core_destruct_sound.stop()
	creditsmusic.play()
	exploded_text.set_visible(true)

	pass # Replace with function body.
