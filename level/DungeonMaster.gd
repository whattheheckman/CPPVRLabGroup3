extends Node




@export var levers_needed := 3
var current_levers := levers_needed

@export var robot : PackedScene
@export var robotlocations : PackedVector3Array
@export var robotrotation : PackedInt32Array

@export var levers_Sound : AudioStreamPlayer
@export var core_destruct_sound : AudioStreamPlayer

@onready var angrymusic = $"Music/Angry Music"
@onready var happymusic = $"Music/Happy Music"

@onready var radio_gain_access = $Radio/GainAccessDialouge


@onready var countdown = $Countdown


# Called when the node enters the scene tree for the first time.
func _ready():

    pass # Replace with function body.

func pulllever():
    current_levers - 1;
    levers_Sound.play()
    if (current_levers <= 0):
        doomsday()
    
func doomsday():
    happymusic.stop()
    angrymusic.start()
    await get_tree().create_timer(2.0).timeout
    countdown.start()
    core_destruct_sound.play()
    
    for location in robotlocations:
        var new_robot = robot
        new_robot.health = 10
        new_robot.set_global_position(location)
        get_tree().root.add_child(new_robot)
    
    
    
    
    
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    pass
func _physics_process(delta):
    while not countdown.is_stopped():
        





func _on_safezone_body_entered(body):
    pass # Replace with function body.
