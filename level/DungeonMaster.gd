extends Node




var total_levers = 3
var current_levers = 3



@onready var leversSound = $Announcer/Deactivated
@onready var core_destruct_sound = $Announcer/Sequence

@onready var angrymusic = $"Music/Angry Music"
@onready var happymusic = $"Music/Happy Music"

@onready var radio_gain_access = $Radio/GainAccessDialouge
@onready var radio_deactivate = $Radio/DeactivateDialouge

@onready var countdown = $Countdown


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func pulllever():
	current_levers - 1;
	leversSound.play()
	if (current_levers <= 0):
		doomsday()
	
func doomsday():
	happymusic.stop()
	angrymusic.start()
	await  get_tree().create_timer(2.0).timeout
	countdown.start()
	core_destruct_sound.play()
	
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass




