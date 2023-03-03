extends MeshInstance3D


@export(int) var height;
@export(int) var width;
@export(int) var depth;




func _ready():
    var surface_array = []
    surface_array.resize(Mesh.ARRAY_MAX)

    # PackedVector**Arrays for mesh construction.
    var verts = PackedVector3Array()
    var uvs = PackedVector2Array()
    var normals = PackedVector3Array()
    var indices = PackedInt32Array()

    #######################################
    ## Insert code here to generate mesh ##
    #######################################

	# calulate height by returning 2 vector3 with y coming from export var height



    # Assign arrays to surface array.
    surface_array[Mesh.ARRAY_VERTEX] = verts
    surface_array[Mesh.ARRAY_TEX_UV] = uvs
    surface_array[Mesh.ARRAY_NORMAL] = normals
    surface_array[Mesh.ARRAY_INDEX] = indices

    # Create mesh surface from mesh array.
    # No blendshapes, lods, or compression used.
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)