extends Node3D
var dungeon_master

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_lever_hinge_moved(angle):
	if (angle > 45):
		dungeon_master.levers -= 1;
	pass # Replace with function body.
