extends CharacterBody3D

@export var BULLET_VELOCITY : float = 20

var time_alive = 5
var hit = false

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collision_shape : CollisionShape3D = $CollisionShape3D
@onready var hit_sound : AudioStreamPlayer3D = $ExplosionAudio

func _physics_process(delta):
	if hit:
		return
	time_alive -= delta
	if time_alive < 0:
		hit = true
		animation_player.play("explode")
	var col = move_and_collide(-delta * BULLET_VELOCITY * transform.basis.z)
	if col:
		if col.get_collider() and col.get_collider().has_method("hit"):
			col.get_collider().hit()
		collision_shape.disabled = true
		hit_sound.pitch_scale = randf_range(0.95, 1.05)
		animation_player.play("explode")
		hit = true
