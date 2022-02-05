extends Node

export(PackedScene) var mob_scene
var score = 0

func _ready():
	randomize()
	get_tree().call_group("leaderboard", "hide")
	#new_game()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_MobTimer_timeout():
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation");
	mob_spawn_location.offset = randi()
	
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	add_child(mob)
	
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	
	""""
	print("Angle to player:")
	print(mob.position.angle_to($Player.position))
	var direction = mob.position.angle_to($Player.position)
	"""
	
	mob.look_at($Player.position)
	
	"""
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	"""
	
	# Choose the velocity.
	var velocity = Vector2(1, 0).rotated(mob.rotation + rand_range(-PI / 4, PI / 4)) * get_random_speed()
	#var velocity = Vector2(rand_velocity, rand_velocity)
	mob.linear_velocity = velocity#.rotated(direction)
	
func get_random_speed():
	if score > 13:
		$ShakeCamera2D.add_trauma(0.4)
		return rand_range(350.0, 450.0)
	if score > 5:
		$ShakeCamera2D.add_trauma(0.25)
		return rand_range(250.0, 350.0)
	return rand_range(150.0, 250.0)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
	if score > 20:
		var temp = $MobTimer.wait_time - 0.5
		if temp > 0:
			$MobTimer.wait_time = temp


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_HUD_show_leaderboard():
	# do swap logic ? 
	print("my signal works at least?")
	
	#var leaderboard_scene = load("res://Leaderboard.tscn")
	#$HUD.replace_by(leaderboard_scene.instance())
	
	$Leaderboard.updateLeaderboard()
	get_tree().call_group("hud", "hide")
	get_tree().call_group("leaderboard", "show")

func showHud():
	get_tree().call_group("hud", "show")
	get_tree().call_group("leaderboard", "hide")
	
