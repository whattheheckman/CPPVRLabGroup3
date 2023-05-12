extends Node3D
@export var dungeon_master : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_lever_hinge_moved(angle):
	if angle > abs(35):
		dungeon_master.pulllever()

