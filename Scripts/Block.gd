extends StaticBody2D

onready var gameVariables = get_node("/root/GameVariables")
var hitSoundScene = preload("res://Scenes/BlockHitSound.tscn")
var audioStream = preload("res://Audio/block-hit.wav")
var life
var currentLevel
var side = 126
var gap = 8

var drop = true
var drop_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/Label.text = str(life)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if drop:
		position = position.linear_interpolate(Vector2(position.x,position.y+side+gap),0.04)
		drop_count+=1
		if drop_count==(1/0.04):
			drop_count = 0
			drop = false
	pass

func isFloorTouched():
	if position.y >= (side+gap)*6:
		return true
	return false
	
func setPosition(i):
	position = Vector2((i+1)*gap+i*side,gap)
	
func setLife(new_life):
	self.life = new_life
	
func updateColor(level):
	self.currentLevel = level
	self.set_modulate(Color(0.83,0.82,0.05,0.78).linear_interpolate(Color(0.81,0.02,0.02,1), 1-float(self.life)/float(self.currentLevel)))
	
func hitted():
	print("Hitted!")
	life-=1
	$Sprite/Label.text = str(life)
	updateColor(self.currentLevel)
	var sound = hitSoundScene.instance()
	add_child(sound)
	if(life == 0):
		gameVariables.block_destroyed+=1
		sound.connect("audio_finished",self,"_destroyed_audio_finisihed")
		sound.play_sound_destroy(audioStream)
		visible = false
		$CollisionShape2D.disabled = true
		
	else:
		sound.play_sound_hit(audioStream)
		
func _destroyed_audio_finisihed():
	self.destroyed()

func dropDown():
#	position.y += (side+gap)
	#position = position.linear_interpolate(Vector2(position.x,position.y+side+gap),0.1)
	drop = true
	
func destroyed():
	queue_free()
