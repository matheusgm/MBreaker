extends PanelContainer

var achievement_id
var achievement_name
var achievement_description
var percent_value

func _ready():
	$HBoxContainer/VBoxContainer/Name.text = achievement_name
	$HBoxContainer/VBoxContainer/Description.text = achievement_description
	$HBoxContainer/Image.texture = load("res://Img/Achievements/"+achievement_name+".png")
	if percent_value >= 100:
		percent_value = 100
	$HBoxContainer/VBoxContainer/ProgressBar.value = percent_value
	pass
