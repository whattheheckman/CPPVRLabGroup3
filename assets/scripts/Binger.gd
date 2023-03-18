extends Node3D

############################################
#SCRIPT VARS
############################################

# for easy access to text labels in UI
@onready var create_label = $"../../XRCamera3D/User Interface/Create"
@onready var delete_label = $"../../XRCamera3D/User Interface/Delete"
@onready var count_label = $"../../XRCamera3D/User Interface/Count"

@onready var controller := XRHelpers.get_xr_controller(self)

var start_point = null
var end_point = null

var mesh_count = 0

############################################
#USER VARS
############################################

@export_category("Controller Mappings")
@export var create_button : String = "ax_button"
@export var delete_button : String = "by_button"
@export var trigger : String = "trigger_click"


@export_category("Limits")
@export var max_height : float = 10.0
@export var max_width : float = 10.0
@export var max_depth : float = 10.0
@export var max_meshes : int = 5


@export_category("Materials")
@export var material : Material

@export_category("Debug Switches")
@export var create_mode : bool = false
@export var delete_mode : bool = false
@export var teleport : bool = false

		
func _physics_process(_delta):
	

	if Engine.is_editor_hint():
		$"../FunctionTeleport".set_enabled(false)
	
	#if create_mode == false and delete_mode == false:
		#$"../FunctionTeleport".set_enabled(true)
		
	if create_mode == true and delete_mode == false and controller.is_button_pressed(trigger):
		Input.start_joy_vibration(0, .5,0,.3)
		if start_point == null:
			start_point = controller.get_global_transform().origin
		else:
			end_point = controller.get_global_transform().origin
	else:
		if start_point != null and end_point != null:
			var height = min(abs(end_point.y - start_point.y), max_height)
			var width = min(abs(end_point.x - start_point.x), max_width)
			var depth = min(abs(end_point.z - start_point.z), max_depth)

			if mesh_count < max_meshes:
				create_mesh(height,width,depth)


			start_point = null
			end_point = null
	
	# Check for deletion of meshes
	if delete_mode == true and create_mode == false and controller.is_button_pressed(trigger): # 1 is the index for the grip button on most VR controllers
		var ray_from = controller.get_global_transform().origin 
		var ray_to = ray_from+controller.get_global_transform().basis.z*-10000 # raycast distance is hard coded here 
		var space_state = get_world_3d().direct_space_state 
		var result = space_state.intersect_ray(ray_to) 
		if result: 
			if "mesh" in result.collider.get_groups():
				remove_mesh(result.collider) # just remove it from the scene tree, no need to get fancy 

func create_mesh(height,width,depth):
	var meshInstance=MeshInstance3D.new()
	meshInstance.add_to_group("mesh")
	meshInstance.set_surface_override_material(0,material)
	
	var staticBody=StaticBody3D.new()
	meshInstance.add_child(meshInstance)
	
	var boxShape=BoxShape3D.new()
	boxShape.extents=Vector3(width/2,height/2,depth/2)
	
	var collisionShape=CollisionShape3D.new()
	collisionShape.shape=boxShape
	staticBody.add_child(staticBody)
	
	
	mesh_count += 1
	meshInstance.name = "BingerBox" + mesh_count
	add_child(meshInstance)
	Input.start_joy_vibration(0, 0,.5,.5)
	count_label.text = mesh_count + " / " +  max_meshes
	
	pass

func remove_mesh(mesh):
	
	mesh.queue_free()
	mesh_count -= 1
	Input.start_joy_vibration(0, 0,.5,.5)
	count_label.text = mesh_count + " / " +  max_meshes

	pass
	
func _input(_event):
	
	if controller.is_button_pressed(create_button): 
		create_mode = !create_mode
		if create_mode == true:
			$"../FunctionTeleport".set_enabled(false)
		delete_mode = false

		create_label.text = "Create mode: " + str(create_mode)
		delete_label.text = "Delete mode: " + str(delete_mode)

	elif controller.is_button_pressed(delete_button):
		delete_mode = !delete_mode
		if delete_mode == true:
			$"../FunctionTeleport".set_enabled(false)
		create_mode = false
	
		create_label.text = "Create mode: " + str(create_mode)
		delete_label.text = "Delete mode: " + str(delete_mode)
