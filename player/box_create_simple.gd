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

@onready var raycast = self
@export var visualize_mesh : MeshInstance3D

var stick_y_pos : float = 0

var mesh_count = 0
var created_meshes = []

############################################
#USER VARS
############################################

@export_category("Controller Mappings")
@export var create_button : String = "ax_button"
@export var delete_button : String = "by_button"
@export var trigger : String = "trigger_click"
@export var input_action : String = "primary"


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

@export_category("Range settings")
@export var max_range : int = 20
@export var stick_deadzone: int = 5
var current_range : int = max_range

func _input(_event):
	
	
	if Input.is_action_pressed("ui_accept"):
			##var timer = Timer.new()
			##timer.autostart = true
			##timer.start(1)
			##if (timer.is_stopped()):
				
		create_mesh(max_height,max_width,max_depth, raycast.get_collision_point)

func _physics_process(delta):
	stick_y_pos = controller.get_vector2(input_action).y
	#range changing with joystick
	if stick_y_pos > stick_deadzone:
		current_range += delta
		clamp(current_range, .5 , max_range)
		pass
	elif  -stick_y_pos < stick_deadzone:
		current_range -= delta
		clamp(current_range, .5 , max_range)
		pass
	#box visualization with left hand
	if raycast.is_colliding() and controller.get_float("trigger") < 0.5:
		visualize_mesh.global_transform.origin = raycast.get_collision_point()
		visualize_mesh.visible = true
	else:
		visualize_mesh.visible = false
		
	
	
		
		

func create_mesh(height : float,width : float, depth : float, location : Vector3):

	##########################################
	######    COLLISION + SCENETREE   ########
	##########################################

	# Create a new MeshInstance node and assign the generated mesh to it
	var meshInstance=MeshInstance3D.new()
	meshInstance.add_to_group("mesh")
	var mesh = BoxMesh.new()
	mesh.surface_set_material(0,material)
	mesh.set_size(Vector3(width/2,height/2,depth/2))
	meshInstance.mesh = mesh

	
	var staticBody=StaticBody3D.new()
	meshInstance.add_child(staticBody)
	
	var boxShape=BoxShape3D.new()
	boxShape.extents=Vector3(width/4,height/4,depth/4) #for some reason the colission seemed to be 2x the size it needed to be

	var collisionShape=CollisionShape3D.new()
	collisionShape.shape=boxShape
	staticBody.add_child(collisionShape)
	
	
	mesh_count += 1
	
	if mesh_count >= max_meshes:
		var oldestMesh = created_meshes.pop_front()
		oldestMesh.queue_free()
	
	meshInstance.name = "PlayerPlatform" + str(mesh_count)
	meshInstance.set_global_position(location)
	get_tree().root.add_child(meshInstance) # just add child would parent it to this Binger node
	created_meshes.push_back(meshInstance)
	controller.trigger_haptic_pulse("haptic",200,1,.3,0)
	#count_label.text = str(mesh_count) + " / " +  str(max_meshes)

	
	pass


@warning_ignore("shadowed_variable_base_class") #these functions are automatically created by signals, so i think i should ignore the warnings
func _on_left_hand_button_pressed(name):
	if name == create_button:
		if current_range == max_range:
			create_mesh(2.5,2.5,2.5, raycast.get_collision_point())
		elif current_range < max_range:
			create_mesh(2.5,2.5,2.5, raycast.get_collision_point() - Vector3(0,0,current_range))


@warning_ignore("shadowed_variable_base_class")
func _on_left_hand_input_float_changed(name, value):
	print("Name: ")
	print(name)
	print("value: ")
	print(value)
	if name == "trigger" and value > 0.5:
		visualize_mesh.visible = false
		pass
