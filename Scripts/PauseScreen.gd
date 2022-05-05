extends Control

var music_bus = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	if AudioServer.is_bus_mute(music_bus):
		$PanelContainer/VBoxContainer/HBoxContainer/MuteButton.pressed = true
	pass # Replace with function body.


func _on_ContinueButton_pressed():
	get_tree().paused = false
	queue_free()
	print("Game Unpaused!")
	pass # Replace with function body.


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.


func _on_MuteButton_pressed():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
