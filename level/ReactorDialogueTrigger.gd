extends Area3D
@export var dialogue : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if (body is Player) or (body is XRCamera3D) or (body.name == "Target"):
		dialogue.play()
