extends Node2D

onready var timer = get_node("Timer")

var topLevel
var canThrow
var maxBullets
var currentBullets
var initialPosition = Vector2()
var finalPosition = Vector2()
var diferencePosition = Vector2()
var shotDirection = Vector2()
var bullet_aim_sprite

signal drawBulletAim
signal throwOneBullet

# Called when the node enters the scene tree for the first time.
func _ready():
	topLevel = 0
	canThrow = true
	maxBullets = 1;
	currentBullets = 0;
	bullet_aim_sprite = load("res://Img/Bullets/Bullet_aim.png")

func set_bullet_wait_time(bullet):
	var d = 50
	var r = bullet.getColisionRadius()
	var speed = bullet.speed.y
	var time_between_bullets = (2*r + d)/(speed*sqrt(2))
	timer.set_wait_time(time_between_bullets)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$NumberBalls.text = str(maxBullets-currentBullets)
	if currentBullets == maxBullets:
		timer.stop()

func restart():
	canThrow = true
	maxBullets = 1;
	currentBullets = 0;
		

func throwBullet():
	emit_signal("throwOneBullet",position,shotDirection)
	currentBullets+=1
	

func _on_Timer_timeout():
	throwBullet()


func _on_GameArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		print(event)
		if event.is_pressed():
			print("pressed: "+str(event.position))
			initialPosition = event.position
			if(canThrow):
				# draw the aim
				for _i in range(20):
					var aim = Sprite.new()
					aim.texture = bullet_aim_sprite
					aim.position = Vector2(0,0)
					aim.scale = Vector2(0.0625,0.0625)
					$BulletAim.add_child(aim)
				pass
		else:
			print("unpressed: "+str(event.position))
			if(canThrow): #and diferencePosition.length() > 50):	
				timer.start()
				throwBullet()
				canThrow = false
			# erase the aims
			if($BulletAim.get_child_count()>0):
				for ch in $BulletAim.get_children():
					ch.queue_free()
				
	if event is InputEventScreenDrag:
		#print("drag: "+str(event.position))
		if(canThrow):
			finalPosition = event.position
			diferencePosition = (finalPosition - initialPosition)
			shotDirection = diferencePosition.normalized();

			# Verification to not throw the bullet down
			if(shotDirection.y < 0.1): 
				shotDirection.y = 0.1
				if(shotDirection.x > 0):
					shotDirection.x = sqrt(1-pow(shotDirection.y,2))
				else:
					shotDirection.x = -sqrt(1-pow(shotDirection.y,2))
			
			emit_signal("drawBulletAim",shotDirection)
