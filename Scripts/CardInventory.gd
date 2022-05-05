extends VBoxContainer

onready var gameVariables = get_node("/root/GameVariables")
var object_name
var bullet_id
var bullet_name
var locked

# Called when the node enters the scene tree for the first time.
func _ready():
	locked = true
	$Name.text = bullet_name
	pass # Replace with function body.

func setImage():
	locked = false
	if object_name !=null:
		$Panel/Image.texture = load("res://Img/Bullets/"+object_name+".png")

func setBullet():
	if(object_name != null):
		gameVariables.bullet_object_name = object_name
