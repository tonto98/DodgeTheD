extends CanvasLayer

signal start_game
signal show_leaderboard

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	
	$NameInput.show()
	$Title.show()
	$SubmitButton.show()
	
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	$LeaderboardButton.hide()
	emit_signal("start_game")

func _on_LeaderboardButton_pressed():
	emit_signal("show_leaderboard")


func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$PostHighscore.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	print(result, response_code, headers, body) # [111, 107] - "ok"
	#proceed_to_main()

func _on_SubmitButton_pressed():
	if $NameInput.text != "":
		persist_player_name($NameInput.text)
		var parent = get_tree().get_root().get_node("Main")
		print(parent.score)
		print("Sending " + $NameInput.text + " ")
		var data = {
			"name" : $NameInput.text,
			"score" : parent.score,
			"timestamp" : "-4"
		}
		_make_post_request("https://us-central1-kviz-a185e.cloudfunctions.net/postHighscore", data, true)
	proceed_to_main()

func persist_player_name(content):
	var file = File.new()
	file.open("user://player_name.dat", File.WRITE)
	file.store_string(content)
	file.close()

func proceed_to_main():
	print("proceed to main")
	$Title.hide()
	$NameInput.hide()
	$SubmitButton.hide()
	
	$Message.text = "Dodge the\nDICKS!"
	$Message.show()
	
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$LeaderboardButton.show()
