extends XRToolsPickable

@onready var shoot_from = $ShootFrom

@onready var fire_cooldown = $FireCooldown


@onready var raycast : RayCast3D = $RayCast3D
@onready var laser : MeshInstance3D = $RayCast3D/Laser

@onready var sound_effect_shoot = $Shoot

@onready var shoot_particle = $ShootFrom/ShootParticle
@onready var muzzle_particle = $ShootFrom/MuzzleFlash
@onready var animation : AnimationPlayer = $AnimationPlayer




func _physics_process(_delta):
    #Laser sight
    if raycast.is_colliding():
        laser.global_transform.origin = raycast.get_collision_point()
        laser.visible = true
    else:
        laser.visible = false
        
        



func _on_action_pressed(_pickable):
    if fire_cooldown.time_left == 0:
        
        var shoot_target = raycast.get_collision_point()
        var shoot_dir = (shoot_target - shoot_from.position).normalized()

        var bullet = preload("res://player/bullet/bullet.tscn").instantiate()
        get_parent().add_child(bullet)

        # If we don't rotate the bullets there is no useful way to control the particles ..
        bullet.look_at_from_position(shoot_from.global_transform.origin, shoot_target, Vector3.UP)
        bullet.add_collision_exception_with(self)
        shoot_particle.restart()
        shoot_particle.emitting = true
        #muzzle_particle.restart()
        #muzzle_particle.emitting = true
        fire_cooldown.start()
        animation.play("shoot_recoil")
        by_controller.trigger_haptic_pulse("haptic",60,2,.3,0)
    pass # Replace with function body.
