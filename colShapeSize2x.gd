@tool
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
        doubleSize()
        pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass


func doubleSize() -> void:
    var tree = get_tree
    for node in tree.get_children():
        if node.is_class("CollisionShape3D"):
            var shape = node.get_shape()
            shape.set_size(shape.get_size() * 2)
            print_debug(node + "size doubled")


