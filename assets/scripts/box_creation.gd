@tool
extends CSGBox3D

var box = CSGBox3D.new()
var sizing = Vector3(1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	box.set_size(sizing)
	pass


## make 8 vertices where ever the player places the first point, when they place the second point moove vertices 3&4 to it. when they move move ot the right for the 3rd point, palce verts 5&6, when they move to the back , move 2/4/6 all with 8 to the back