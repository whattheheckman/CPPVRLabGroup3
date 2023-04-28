extends Node3D

@onready var shoot_from = player_model.get_node("Robot_Skeleton/Skeleton3D/GunBone/ShootFrom")

@onready var fire_cooldown = $FireCooldown


@onready var sound_effects = $SoundEffects
@onready var sound_effect_jump = sound_effects.get_node("Jump")
@onready var sound_effect_land = sound_effects.get_node("Land")
@onready var sound_effect_shoot = sound_effects.get_node("Shoot")

func _physics_process(delta):


	if Input.is_action_pressed("shoot") and fire_cooldown.time_left == 0:
		var shoot_origin = shoot_from.global_transform.origin

		var ch_pos = crosshair.position + crosshair.size * 0.5
		var ray_from = camera_camera.project_ray_origin(ch_pos)
		var ray_dir = camera_camera.project_ray_normal(ch_pos)

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
		var shoot_particle = $PlayerModel/Robot_Skeleton/Skeleton3D/GunBone/ShootFrom/ShootParticle
		shoot_particle.restart()
		shoot_particle.emitting = true
		var muzzle_particle = $PlayerModel/Robot_Skeleton/Skeleton3D/GunBone/ShootFrom/MuzzleFlash
		muzzle_particle.restart()
		muzzle_particle.emitting = true
		fire_cooldown.start()
		sound_effect_shoot.play()
