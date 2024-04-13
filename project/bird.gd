extends Area2D

var player_speed
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_speed = -Global.speed/100
	position.x+=player_speed
	if(player_speed!=0):
		$AnimatedSprite2D.play("fly")




