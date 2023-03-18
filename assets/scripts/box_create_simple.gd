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
			##var timer = Timer.new()
			##timer.autostart = true
			##timer.start(1)
			##if (timer.is_stopped()):
				start_point = controller.position
				create_mesh(max_height,max_width,max_depth)



func create_mesh(height,width,depth):

	##########################################
	######     GEOMETRY CREATION      ########
	##########################################

	# Create a new SurfaceTool instance
	var st = SurfaceTool.new()

	# Begin the surface tool and set the primitive type to triangles
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Generate the vertices of the cube
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-width/2, height/2, -depth/2))
	
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-width/2, height/2, depth/2))
	
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(width/2, height/2, depth/2))
	
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(width/2, height/2, -depth/2))
	
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-width/2, -height/2, -depth/2))
	
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-width/2, -height/2, depth/2))
	
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(width/2, -height/2, depth/2))
	
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(width/2, -height/2, -depth/2))
	
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-width/2, height/2, -depth/2))
	

	# Set smooth groups for each face
	st.set_smooth_group(0)

	# Generate normals for the mesh
	st.generate_normals()
	st.generate_tangents()

	# Index the vertices of the mesh
	#st.index()

	# Generate the surface tool mesh and assign it to a new Mesh instance
	var mesh = st.commit()


	##########################################
	######    COLLISION + SCENETREE   ########
	##########################################

	# Create a new MeshInstance node and assign the generated mesh to it
	var meshInstance=MeshInstance3D.new()
	meshInstance.add_to_group("mesh")
	meshInstance.mesh = mesh
	meshInstance.set_surface_override_material(0,material)
	
	var staticBody=StaticBody3D.new()
	meshInstance.add_child(staticBody)
	
	var boxShape=BoxShape3D.new()
	boxShape.extents=Vector3(width/2,height/2,depth/2)
	
	var collisionShape=CollisionShape3D.new()
	collisionShape.shape=boxShape
	staticBody.add_child(collisionShape)
	
	
	mesh_count += 1
	meshInstance.name = "BingerBox" + str(mesh_count)
	meshInstance.position = start_point
	add_child(meshInstance)
	
	Input.start_joy_vibration(0, 0,.5,.5)
	count_label.text = str(mesh_count) + " / " +  str(max_meshes)
	
	pass
