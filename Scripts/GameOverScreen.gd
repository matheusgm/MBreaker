extends Control

var tween
var tween_values = [Vector2(0.8, 0.8),Vector2(1, 1)]
var main_menu_btn

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_btn = $PanelContainer/VBoxContainer/MainMenuButton
	main_menu_btn.rect_pivot_offset = main_menu_btn.rect_size/2
	tween = get_node("Tween")
	_start_tween()
	pass # Replace with function body.


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.

func _start_tween():
	tween.interpolate_property(main_menu_btn, "rect_scale",
		tween_values[0],tween_values[1] , 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start()

func _on_Tween_tween_completed(object, key):
	tween_values.invert()
	_start_tween()
