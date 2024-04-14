extends CharacterBody2D
var heart=3
var score = 0
# Define player speed
var speed : float = 500
# Define player jump speed
var jump_speed = -80
var gravity = 4600
# Define player velocity
var damage_ip=false
var game_on = false

func _ready():
	velocity.x=speed
func _physics_process(delta):
	# Apply gravity
	$run.disabled=false
	$duck.disabled=true
	Global.speed=velocity.x
	if game_on:
		score+=0.0001*speed
		Global.score=score
		if speed>1000:
			speed=1000
		if damage_ip:
			$AnimatedSprite2D.play("damage")
			velocity.y=Vector2(0,0).y
		else:
			velocity.y += gravity * delta * 1.4
			if is_on_floor() and Input.is_action_pressed("jump"):
				velocity.y = jump_speed
				print("jump")
				$jump_sound.play()
			elif Input.is_action_pressed("duck"):
				$AnimatedSprite2D.play("duck")
				velocity.y+=200
				$duck.disabled=false
				$run.disabled=true
			elif is_on_floor():
				$AnimatedSprite2D.play("run")
			if not is_on_floor():
				$AnimatedSprite2D.play("jump")
		move_and_slide()
	else:
		$AnimatedSprite2D.play("idle")


func player():
	pass

func damage():
	if damage_ip==false:
		heart-=1
		damage_ip=true
		$damage_time.start()
		$damage.play()


func _on_damage_time_timeout():
	$damage.stop()
	$damage_time.stop()
	if(heart<=0):
		Global.game_over=true
	damage_ip=false
	
func new_game():
	heart=3
	$speed.start()
	# Define player speed
	speed = 500
	score=0
	# Define player jump speed
	jump_speed = -2000
	gravity = 4200
	# Define player velocity
	damage_ip=false
	game_on = false


func _on_speed_timeout():
	speed+=20
	velocity.x=speed
