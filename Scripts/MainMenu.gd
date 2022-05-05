extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game.tscn")
	pass # Replace with function body.


func _on_Inventory_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Inventory.tscn")
	pass # Replace with function body.


func _on_Achievements_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Achievements.tscn")
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.

