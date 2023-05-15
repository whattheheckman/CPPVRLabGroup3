extends XRToolsPickable

# TODO: make bullet scene selectable so we can change the type of bullet easier
#@export var bullet : PackedScene = preload("res://player/bullet/bullet.tscn") 
@export var bullet_speed : float = 10

@onready var shoot_from = $ShootFrom

@onready var fire_cooldown = $FireCooldown


@onready var raycast : RayCast3D = $RayCast3D
@onready var laser : MeshInstance3D = $RayCast3D/Laser

@onready var sound_effect_shoot = $Shoot

@onready var shoot_particle = $ShootFrom/ShootParticle
@onready var muzzle_particle = $ShootFrom/MuzzleFlash
@onready var animation : AnimationPlayer = $AnimationPlayer

func ready():
	if OS.get_name() == "Android":
		$blasterA/OmniLight3D.shadow_enabled = false

func _physics_process(_delta):
	#Laser sight
	if raycast.is_colliding():
		laser.global_transform.origin = raycast.get_collision_point()
		laser.visible = true
	else:
		laser.visible = false
		
		



func _on_action_pressed(_pickable):
	if fire_cooldown.time_left == 0:
		
		var shoot_origin = shoot_from.global_transform.origin
		
		var shoot_target = raycast.get_collision_point()
		var shoot_dir = (shoot_target - shoot_from.position).normalized()

		var bullet = preload("res://player/bullet/bullet.tscn").instantiate()
		bullet.set_as_top_level(true)
		get_tree().get_root().add_child(bullet)
		bullet.look_at_from_position(shoot_origin,shoot_target,Vector3.UP)
		
		bullet.add_collision_exception_with(self)
		
		# If we don't rotate the bullets there is no useful way to control the particles ..
		
		shoot_particle.restart()
		shoot_particle.emitting = true
		#muzzle_particle.restart()
		#muzzle_particle.emitting = true
			
		fire_cooldown.start()
		animation.play("shoot_recoil")
		by_controller.trigger_haptic_pulse("haptic",60,2,.3,0)
	pass # Replace with function body.
