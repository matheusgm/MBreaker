extends Control

onready var jsonManager = get_node("/root/JsoNmanager")
onready var db = get_node("/root/Database")
var cardAchievementsLoad = preload("res://Scenes/CardAchievements.tscn")
var db_result

func _ready():
	db_result = db.getStatistics()[0]
	
	var goal_name = ""
	var goal_value = ""
	for i in range(len(jsonManager.achievements)):
		var card = cardAchievementsLoad.instance()
		card.achievement_id = jsonManager.achievements[i].achievement_id
		card.achievement_name = jsonManager.achievements[i].name
		card.achievement_description = jsonManager.achievements[i].description
		goal_name = jsonManager.achievements[i].goal.name
		goal_value = jsonManager.achievements[i].goal.value
		card.percent_value = (db_result[goal_name]*100/goal_value)
		$List/VBoxContainer.add_child(card)
		if card.percent_value >= 100:
			get_reward(jsonManager.achievements[i].reward)

func get_reward(rewards):
	var bullets = db.getBullets()
	for rew in rewards:
		if rew == "bullet_id":
			win_bullet(rewards["bullet_id"],bullets)
	
func win_bullet(id, bullets):
	for i in bullets:
		if i["json_id"] == id:
			# We already won these bullet
			return
	# We didnt won these bullet
	db.insertNewBullet(id)

func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.
