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


func _input(_event):
	if Input.is_action_pressed("ui_accept"):
		if mesh_count < max_meshes:
			create_mesh(max_height,max_width,max_depth)



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