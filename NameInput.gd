extends TextEdit
signal inpu_enter

export(int) var LIMIT = 15
var current_text = ''
var cursor_line = 0
var cursor_column = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var name = load_player_name()
	text = name
	grab_focus()

func load_player_name():
	var file = File.new()
	file.open("user://player_name.dat", File.READ)
	var content = file.get_as_text()
	print("content " + content)
	file.close()
	return content

func _on_NameInput_text_changed():
	if("\n" in text):
		text = text.replace("\n", "")
		get_parent()._on_SubmitButton_pressed()
	var new_text : String = text
	if new_text.length() > LIMIT:
		text = current_text
		# when replacing the text, the cursor will get moved to the beginning of the
		# text, so move it back to where it was 
		cursor_set_line(cursor_line)
		cursor_set_column(cursor_column)

	current_text = text
	# save current position of cursor for when we have reached the limit
	cursor_line = cursor_get_line()
	cursor_column = cursor_get_column()
