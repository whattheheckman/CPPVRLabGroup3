extends Area3D

@export var impulse_factor = 10.0

var object_in_area = Array()
var picked_up_object = null

var last_position = Vector3(0.0, 0.0, 0.0)
var velocity = Vector3(0.0, 0.0, 0.0)


func _on_body_entered(body):
	if body.has_method('pick_up') and object_in_area.find(body) == -1:
		object_in_area.push_back(body)


func _on_body_exited(body):
	if object_in_area.find(body) != -1:
		object_in_area.erase(body)

func _on_button_pressed(p_button):
	if p_button == 2:
		if picked_up_object:
			picked_up_object.let_go(velocity * impulse_factor)
			picked_up_object = null
		elif !object_in_area.empty():
			picked_up_object = object_in_area[0]
			picked_up_object.pick_up(self)
			
func _ready():
	#get_parent().connect("button_pressed", self, "_on_button_pressed")
	last_position = global_transform.origin
	
func _process(delta):
	velocity = global_transform.origin - last_position / delta
	last_position = global_transform.origin
			
