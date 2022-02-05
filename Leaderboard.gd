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
	var result = "#  SCORE PLAYER\n\n"
	var i = 0
	var topTen = list.slice(0, 9, 1, false)
	for item in topTen:
		i += 1
		var rank = "%02d" % i
		var score = "%03d" % int(item.score)
		result += rank + ".  " + score + "   " + item.name + "\n"
	return result


func _on_BackButton_pressed():
	get_tree().get_root().get_node("Main").showHud()
