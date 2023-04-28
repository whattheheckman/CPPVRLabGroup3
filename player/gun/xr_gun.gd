extends XRToolsPickable

@onready var shoot_from = $ShootFrom

@onready var fire_cooldown = $FireCooldown

@onready var crosshair : Sprite3D = $Crosshair
@onready var xrcameragroup = get_tree().get_nodes_in_group("xrcamera")
@onready var xrcam : XRCamera3D = xrcameragroup[0]

@onready var raycast : RayCast3D = $RayCast3D
@onready var laser : MeshInstance3D = $RayCast3D/Laser

@onready var sound_effect_shoot = $Shoot

@onready var shoot_particle = $ShootFrom/ShootParticle
@onready var muzzle_particle = $ShootFrom/MuzzleFlash



func _physics_process(_delta):
	#Laser sight
	if raycast.is_colliding():
		laser.global_transform.origin = raycast.get_collision_point()
		laser.visible = true
	else:
		laser.visible = false
		
		



func _on_action_pressed(_pickable):
	if fire_cooldown.time_left == 0:
		var shoot_origin = shoot_from.position

		var ch_pos = crosshair.position + Vector3(crosshair.get_frame_coords().x, crosshair.get_frame_coords().y,0) * 0.5
		var ray_from = shoot_from.position
		var ray_dir = xrcam.project_ray_normal(Vector2(ch_pos.x,ch_pos.y))

		var shoot_target
		var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_from, ray_dir * 1000, 1, [self])
		var col = get_world_3d().direct_space_state.intersect_ray(query) # ray_from + ray_dir * 1000
		if col.is_empty():
			shoot_target = ray_from + ray_dir * 1000
		else:
			shoot_target = col.position
		var shoot_dir = (shoot_target - shoot_origin).normalized()

		var bullet = preload("res://player/bullet/bullet.tscn").instantiate()
		get_parent().add_child(bullet)
		bullet.global_transform.origin = shoot_origin
		# If we don't rotate the bullets there is no useful way to control the particles ..
		bullet.look_at(shoot_origin + shoot_dir, Vector3.UP)
		bullet.add_collision_exception_with(self)
		shoot_particle.restart()
		shoot_particle.emitting = true
		muzzle_particle.restart()
		muzzle_particle.emitting = true
		fire_cooldown.start()
		sound_effect_shoot.play()
	pass # Replace with function body.
