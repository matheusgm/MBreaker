extends KinematicBody2D

export var speed = Vector2(1500,1500)
var colision
var isFirstBulletOut = false

signal firstBulletOut


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	colision = move_and_collide(speed*delta)
	
	if(colision):
		print(colision.collider.get_groups())
		if(colision.collider.is_in_group("Wall")):
			speed = speed.bounce(colision.normal)
		elif(colision.collider.is_in_group("Block")):
			if (colision.collider.has_method("hitted")):
				colision.collider.hitted()
			speed = speed.bounce(colision.normal)
		elif(colision.collider.is_in_group("Floor")):
			if(not isFirstBulletOut):
				emit_signal("firstBulletOut",self.position.x)
			self.destroyed()
			
func getColisionRadius():
	return $CollisionShape2D.shape.radius
		
func setSprite(new_sprite):
	$Sprite.texture = new_sprite

func setDirection(direction):
	direction*=-1
	speed*=direction
	
func changeDirection(_new_direction):
	pass
	
func destroyed():
	queue_free()
	pass
