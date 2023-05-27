extends Node3D
@export var dungeon_master : Node
var pulled : bool = false


func _on_interactable_lever_hinge_moved(angle):
	if angle > abs(35) and pulled == false:
		dungeon_master.pulllever()
		pulled = true

