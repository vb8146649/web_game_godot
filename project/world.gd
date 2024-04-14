extends Node2D
var obs_num=1
var highscore : int
var screen_size : Vector2i
var Ground_height: int
var bird_height=[290,520]
const original_text="♥♥♥"
var current_text
var rock = preload("res://rock.tscn")
var barrel= preload("res://barrel.tscn")
var stump = preload("res://stump.tscn")
var bird = preload("res://bird.tscn")
var obs_array:=[rock,barrel,stump,bird]
var background_music
# Called when the node enters the scene tree for the first time.
func _ready():
	highscore = int(highscore_r())
	obs_num=1
	$Menu/high_score.text="HIGH SCORE: "+str(highscore)
	$End.hide()
	screen_size = get_window().size
	$End/Button.pressed.connect(_ready)
	$Menu/play.show()
	current_text=original_text
	$Menu/heart.text=current_text
	Ground_height=$ground/Sprite2D.texture.get_height()
	get_tree().paused=false
	clear_group_objects("enemy")
	#$background.loop=true
	$player.heart=3
	$player.position=Vector2(120,552)
	$ground.position=Vector2(1152,688)
	Global.game_over=false
	$player.new_game()
	background_music=false
	$player/background_music.stop()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($player.position.x-$ground.position.x)
	if Input.is_action_just_pressed("jump"):
		get_node("player").game_on=true
		$Menu/play.hide()
		$enemy_respawn.start()
		if background_music==false:
			background_music=true
			$player/background_music.play()
	if $player.position.x-$ground.position.x > screen_size.x - 1050 : 
		$ground.position.x+= screen_size.x
	$Menu/score.text = "SCORE:" + str(int(Global.score))

func obs():
	var obs_a=obs_array[randi_range(0,3)]
	if(Global.score>400):
		obs_num=2
	elif Global.score>800:
		obs_num=3
	for i in range(randi_range(1,obs_num)):
		var obs_instance = obs_a.instantiate()
		var obs_x=$player/Camera2D.global_position.x+1300+(i-1)*(170)
		var obs_y=screen_size.y
		if obs_a==bird:
			obs_y=bird_height[randi_range(0,1)]
		obs_instance.body_entered.connect(damage)
		obs_instance.position=Vector2(obs_x,obs_y)
		add_child(obs_instance)


func obs_clear():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.position.x < $player/Camera2D.global_position.x -200:
			enemy.queue_free()
			print("yeap")
	
func _on_enemy_respawn_timeout():
	obs()
	obs_clear()

func clear_group_objects(group_name):
	var group_nodes = get_tree().get_nodes_in_group(group_name)
	for node in group_nodes:
		node.queue_free()

func damage(body):
	if body.name=="player":
		body.damage()
		current_text=current_text.substr(0, current_text.length() - 1)
		$Menu/heart.text=current_text
		game_over()
		
func game_over():
	if Global.game_over==true:
		$enemy_respawn.stop()
		$player/speed.stop()
		#$game_over.play()
		if int(Global.score)>highscore:
			highscore=int(Global.score)
			highscore_w()
			$Menu/high_score.text="HIGH SCORE: "+str(highscore)
		get_tree().paused=true
		#$game_over.play()
		$End.show()

func highscore_r():
	var file = FileAccess.open("res://highscore.js",FileAccess.READ)
	var json = JSON.new()
	var json_str = file.get_as_text()
	file.close()
	return json.parse_string(json_str)

func highscore_w():
	var file = FileAccess.open("res://highscore.js",FileAccess.WRITE)
	file.store_string(str(highscore))
	file.close()
