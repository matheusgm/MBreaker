extends Control

# 1080 x 1080 px
# ROW:
#	8 blocos de 126 x 126 px
#	9 espacos entre blocos de 8 px
#
# COLUMN:
#	ultima coluna para player e colisao
#	7 colunas para aparecer blocos

onready var db = get_node("/root/Database")
onready var jsonManager = get_node("/root/JsoNmanager")
onready var gameVariables = get_node("/root/GameVariables")
onready var pauseScene = preload("res://Scenes/PauseScreen.tscn")
onready var gameOverScene = preload("res://Scenes/GameOverScreen.tscn")
var blockLoad = preload("res://Scenes/Block.tscn")
onready var bulletLoad = load("res://Scenes/Bullets/"+gameVariables.bullet_object_name+".tscn")

var currentLevel;
var topLevel;
var nextLevel;
var bullet_sprite;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	currentLevel = 1
	var db_rankboard = db.getTopLevel()
	topLevel = 1
	if len(db_rankboard) != 0:
		topLevel = db_rankboard[0]["level"]
		
	gameVariables.block_destroyed = 0
	$MenuTop/HighScore/VBoxContainer/Score.text = str(topLevel)
	nextLevel = false
	$Player.connect("throwOneBullet",self,"playerThrowBullet")
	addNewRowBlocks()
	$Player.set_bullet_wait_time(bulletLoad.instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$MenuTop/Score.text = str(currentLevel)
	if $Player.currentBullets == $Player.maxBullets and $Bullets.get_child_count() == 0:
		$Player.currentBullets = 0
		if isGameOver():
			print("Game Over!")
			gameOver()
		else:
			nextLevel = true
	if $Bullets.get_child_count() == 0 and nextLevel == true:
		goNextLevel()
		nextLevel = false


func goNextLevel():
	$Player.canThrow = true 
	for block in $Blocks.get_children():
		block.dropDown()
		block.updateColor(currentLevel)
	$Player.maxBullets+=1
	currentLevel+=1
	if currentLevel > topLevel:
		topLevel = currentLevel
		$MenuTop/HighScore/VBoxContainer/Score.text = str(currentLevel)
	addNewRowBlocks()

func addNewRowBlocks():
	var rand_value = randi() % 8+1
	var array = []
	for i in range(8):
		if i < rand_value:
			array.append(true)
		else:
			array.append(false)
	
	array.shuffle()
	for i in range(8):
		if(array[i]):
			var block = blockLoad.instance()
			block.setPosition(i)
			block.setLife(currentLevel)
			block.updateColor(currentLevel)
			$Blocks.add_child(block)
	
func isGameOver():
	for block in $Blocks.get_children():
		if block.isFloorTouched():
			return true
	return false

func gameOver():
	for block in $Blocks.get_children():
		block.destroyed()
	#restartGame()
	var instanceGameOver = gameOverScene.instance()
	add_child(instanceGameOver)
	print("Game Over!")
	get_tree().paused = true
	insertRankboard()
	updateStatistics()
	
func restartGame():
	currentLevel = 1
	gameVariables.block_destroyed = 0
	$Player.restart()
	addNewRowBlocks()

func insertRankboard():
	db.insertRankboard(currentLevel)

func updateStatistics():
	if currentLevel > topLevel:
		topLevel = currentLevel
	db.updateStatistics(str(topLevel), str(GameVariables.block_destroyed))

func _on_PauseButton_pressed():
	var instancePauseScene = pauseScene.instance()
	add_child(instancePauseScene)
	print("Game Paused!")
	get_tree().paused = true

func _on_Player_drawBulletAim(shotDirection):
	# Draw the bullet aim
	for j in range($Player/BulletAim.get_child_count()):
		var ch = $Player/BulletAim.get_child(j)		
		
		var LeftWall_x = $GameAreaLimit/LeftWall/CollisionShape2D.global_position.x
		var LeftWall_w = $GameAreaLimit/LeftWall/CollisionShape2D.shape.extents.x
		var RightWall_x = $GameAreaLimit/RightWall/CollisionShape2D.global_position.x
		var RightWall_w = $GameAreaLimit/RightWall/CollisionShape2D.shape.extents.x
		
		ch.position = Vector2(-shotDirection.x*(j+1)*108,-shotDirection.y*(j+1)*108)
		
		# Verificação para espelhar a mira
		if(ch.global_position.x<LeftWall_x+LeftWall_w):
			ch.global_position.x = ((LeftWall_x+LeftWall_w)*2) - ch.global_position.x
		elif(ch.global_position.x > RightWall_x-RightWall_w):
			ch.global_position.x = (RightWall_x-RightWall_w)*2 - ch.global_position.x
		
		if ch.global_position.y < $GameAreaLimit/TopWall/CollisionShape2D.global_position.y \
		 or ch.global_position.x < (LeftWall_x+LeftWall_w) \
		 or ch.global_position.x > (RightWall_x-RightWall_w):
			ch.visible = false
		else:
			ch.visible = true
		
		pass # Replace with function body.
		
func playerThrowBullet(bulletPosition,bulletShotDirection):
	var bullet = bulletLoad.instance()
	bullet.position = bulletPosition
	bullet.setDirection(bulletShotDirection)
	if $Bullets.get_children().size() != 0 and not $Bullets.get_child(0).isFirstBulletOut:
		bullet.connect("firstBulletOut",self,"_changePositionOnFirstBallDown")
	$Bullets.add_child(bullet)
	
func _changePositionOnFirstBallDown(bulletPositionX):
	$Player.position.x = bulletPositionX
	for bull in $Bullets.get_children():
		bull.isFirstBulletOut = true
	pass
