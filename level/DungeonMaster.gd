extends Node



var all_levers_pulled = false
var levers = 3



@onready var leversSound2 = $"Announcer/2 Levers"
@onready var leversSound1 = $"Announcer/1 Levers"
@onready var core_destruct_sound = $"Announcer/Core Imminent"

@onready var angrymusic = $"Music/Angry Music"
@onready var happymusic = $"Music/Happy Music"

@onready var radio_gain_access = $Radio/GainAccessDialouge
@onready var radio_deactivate = $Radio/DeactivateDialouge

@onready var countdown = $Countdown


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
