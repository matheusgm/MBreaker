extends Control

onready var jsonManager = get_node("/root/JsoNmanager")
onready var db = get_node("/root/Database")
var cardInventoryLoad = preload("res://Scenes/CardInventory.tscn")

var pressdown_position = Vector2()
var press_threshold = 10
var db_results

func _ready():
	
	for i in range(len(jsonManager.bullets)):
		var card = cardInventoryLoad.instance()
		card.connect("gui_input",self,"_on_CardInventory_gui_input",[i])
		card.bullet_id = jsonManager.bullets[i].bullet_id
		card.object_name = jsonManager.bullets[i].object_name
		card.bullet_name = jsonManager.bullets[i].name	
		$BallsList/VBoxContainer.add_child(card)

		
	
	db_results = db.getBullets()
	print(db_results)
	
	for bullet in db_results:
		for card in $BallsList/VBoxContainer.get_children():
			if card.bullet_id == bullet.json_id:
				card.setImage()
				break
	

func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.


func _on_CardInventory_gui_input(event,i):
	if event is InputEventMouseButton: 
		if event.pressed:
			pressdown_position = event.position
		elif event.position.distance_to(pressdown_position) <= press_threshold:
			bulletChoosed(i)
			pass
			
func bulletChoosed(i):
	if not $BallsList/VBoxContainer.get_child(i).locked:
		$BallsList/VBoxContainer.get_child(i).setBullet()
		get_tree().change_scene("res://Scenes/MainMenu.tscn")


