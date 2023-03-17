extends Node3D
@export var max_height : float = 10.0
@export var max_width : float = 10.0
@export var max_depth : float = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


@export var max_meshes : int = 5
var mesh_count = 0


func _input(event):
	if Input.is_action_pressed("ui_accept"):
		if mesh_count < max_meshes:
			create_mesh(max_height,max_width,max_depth)



func create_mesh(height,width,depth):
	
	var staticBody=StaticBody3D.new()
	
	
	
	var meshInstance=MeshInstance3D.new()
	meshInstance.add_to_group("mesh")

	staticBody.add_child(meshInstance)
	
	var boxShape=BoxShape3D.new()
	boxShape.extents=Vector3(width/2,height/2,depth/2)
	
	var collisionShape=CollisionShape3D.new()
	collisionShape.shape=boxShape
	staticBody.add_child(collisionShape)
	
	add_child(staticBody)
	Input.start_joy_vibration(0, 0,.5,.5)

