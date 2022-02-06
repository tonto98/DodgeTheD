extends Node

export(PackedScene) var mob_scene
var score = 0

var test_counter = 0
var camera_trauma = 0.0

var mob_aim_offset = 4

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
	test_counter += 1
	print("Spawning mob: " + str(test_counter))
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
	var velocity = Vector2(1, 0).rotated(mob.rotation + rand_range(-PI / mob_aim_offset, PI / mob_aim_offset)) * get_random_speed()
	#var velocity = Vector2(rand_velocity, rand_velocity)
	mob.linear_velocity = velocity#.rotated(direction)
	
func get_random_speed():
	if score > 30:
		return rand_range(400.0, 450.0)
	if score > 13:
		return rand_range(350.0, 400.0)
	if score > 5:
		return rand_range(250.0, 350.0)
	return rand_range(150.0, 250.0)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
	update_camera_shake()
	update_mob_aim()
	
	if score > 20:
		var temp = $MobTimer.wait_time - 0.005
		if temp > 0.275:
			$MobTimer.wait_time = temp
	print("spawn rate is now: " + str($MobTimer.wait_time))

func update_mob_aim():
	var temp = mob_aim_offset + 0.12
	if temp < 16:
		mob_aim_offset = temp
	print("Mob aim offset is: " + str(mob_aim_offset))

func update_camera_shake():
	if score == 5:
		camera_trauma = 0.25
	if score > 13 and camera_trauma <= 0.35:
		camera_trauma += 0.002
	print("camera trauma is: " + str(camera_trauma))
	$ShakeCamera2D.add_trauma(camera_trauma)

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
	
