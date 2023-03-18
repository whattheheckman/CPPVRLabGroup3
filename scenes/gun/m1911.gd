extends "res://assets/pickable_object.gd"	
 
func _process(_delta):
	if $Aim.is_colliding():
		$Aim/LaserDot.global_transform.origin = $Aim.get_collision_point()
		$Aim/LaserDot.visible = true
	else:
		$Aim/LaserDot.visible = false
