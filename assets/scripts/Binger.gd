extends XRController3D


var start_point = null
var end_point = null

func _process(delta):
	if is_button_pressed(15): # 15 is the index for the trigger button on most VR controllers
		if start_point == null:
			start_point = get_global_transform().origin
		else:
			end_point = get_global_transform().origin
	else:
		if start_point != null and end_point != null:
			var height = abs(end_point.y - start_point.y)
			var width = abs(end_point.x - start_point.x)
			var depth = abs(end_point.z - start_point.z)

			# Create mesh with obtained dimensions here

			start_point = null
			end_point = null
