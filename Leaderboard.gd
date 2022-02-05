extends CanvasLayer

signal leaderboard_closed

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("https://us-central1-kviz-a185e.cloudfunctions.net/getLeaderBoard")

func updateLeaderboard():
	$HTTPRequest.request("https://us-central1-kviz-a185e.cloudfunctions.net/getLeaderBoard")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var scores = json.result
	for score in scores:
		print(score)
	$List.text = getFormattedList(scores)

func getFormattedList(list):
	var result = ""
	var i = 0
	for item in list:
		i += 1
		result += str(i) + ". " + str(item.score) + " " + item.name + "\n"
	return result


func _on_BackButton_pressed():
	get_tree().get_root().get_node("Main").showHud()
