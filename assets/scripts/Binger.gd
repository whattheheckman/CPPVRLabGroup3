extends XRController3D




@export var create_button : String = "ax_button"
@export var delete_button : String = "by_button"


var start_point = null
var end_point = null

@export var max_height : int = 10.0
@export var max_width : int = 10.0
@export var max_depth : int = 10.0

@export_range(1,10) var max_meshes : int = 5
var mesh_count = 0

func _physics_process(_delta):
	if get_node("ARVRController").is_button_pressed(create_button): # 15 is the index for the trigger button on most VR controllers
		if start_point == null:
			start_point = get_node("ARVRController").get_global_transform().origin
		else:
			end_point = get_node("ARVRController").get_global_transform().origin
	else:
		if start_point != null and end_point != null:
			var height = min(abs(end_point.y - start_point.y), max_height)
			var width = min(abs(end_point.x - start_point.x), max_width)
			var depth = min(abs(end_point.z - start_point.z), max_depth)

			if mesh_count < max_meshes:
				create_mesh(height,width,depth)
				mesh_count += 1

			start_point = null
			end_point = null
	
	# Check for deletion of meshes
	if get_node("ARVRController").is_button_pressed(delete_button): # 1 is the index for the grip button on most VR controllers
		var ray_from = get_node("ARVRController").get_global_transform().origin 
		var ray_to = ray_from+get_node("ARVRController").get_global_transform().basis.z*-10000 # raycast distance is hard coded here 
		var space_state = get_world_3d().direct_space_state 
		var result = space_state.intersect_ray(ray_to) 
		if result: 
			if "mesh" in result.collider.get_groups():
				remove_mesh(result.collider) # just remove it from the scene tree, no need to get fancy 

func create_mesh(height,width,depth):
	var meshInstance=MeshInstance.new()
	meshInstance.add_to_group("mesh")
	
	var boxShape=BoxShape.new()
	boxShape.extents=Vector3(width/2,height/2,depth/2)
	
	var collisionShape=CollisionShape.new()
	collisionShape.shape=boxShape
	
	var staticBody=StaticBody.new()
	staticBody.add_child(collisionShape)
	
	var cubeMesh=CubeMesh.new()

func remove_mesh(mesh):
	
	pass
