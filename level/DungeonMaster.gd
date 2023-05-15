extends Node




@export var levers_needed := 3
var current_levers := levers_needed

var in_reactor := false

@export var robot : PackedScene
@export var robotlocations : PackedVector3Array
@export var robotrotation : PackedFloat32Array

@export var levers_Sound : AudioStreamPlayer
@export var core_destruct_sound : AudioStreamPlayer

@onready var reactormusic = $"Music/Reactor Music"
@onready var angrymusic = $"Music/Angry Music"
@onready var happymusic = $"Music/Happy Music"

@onready var radio_gain_access = $Radio/GainAccessDialouge


@onready var countdown = $Countdown
@export var animationPlayer : AnimationPlayer 


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func pulllever():
	current_levers -= 1;
	levers_Sound.play()
	if (current_levers <= 0):
		doomsday()
	
func doomsday():
	happymusic.stop()
	reactormusic.stop()
	angrymusic.play()
	await get_tree().create_timer(2.0).timeout
	countdown.start()
	animationPlayer.play("Doomsday")
	core_destruct_sound.play()
	
	for location in robotlocations:
		var new_robot = robot
		#new_robot.health = 10 #FIXME: not picking up the health field for somereason, probably bc it's a scene
		new_robot.set_global_position(location)
		get_tree().root.add_child(new_robot)
		
	
	
func win():
	pass
	
	
	


func _on_safezone_body_entered(body):
	while not countdown.is_stopped():
		win()



func _on_reactor_dialogue_trigger_body_entered(body):
	if not in_reactor and body is XRCamera3D:
		fade_out(happymusic)
		reactormusic.play()
	
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

func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
	last_stream_faded.volume_db = last_vol
	
	
