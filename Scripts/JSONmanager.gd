extends Node

var bullets
var achievements

func _ready():
	bullets = parseJSON("res://DataStore/bullets.json")
	achievements = parseJSON("res://DataStore/achievements.json")
	pass 

	
func parseJSON(filePath):
	var data_file = File.new()
	if data_file.open(filePath, File.READ) != OK:
		print("Error in reading JSON file!")
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print("Error in parsing JSON")
		return 
	return data_parse.result

