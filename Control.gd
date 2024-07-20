extends Control

enum Player {NONE,PLAYER_X,PLAYER_O}

var board = [Player.NONE,Player.NONE,Player.NONE,
			Player.NONE,Player.NONE,Player.NONE,
			Player.NONE,Player.NONE,Player.NONE]
			
var current_player = Player.PLAYER_X

func _ready():
	for i in range(9):
		$GridContainer.get_child(i).connect("pressed",self,"_on_button_pressed",[i])
	#set button size
	var container_size = $GridContainer.rect_size
	var button_size = min(container_size.x /3 , container_size.y / 3)
	for button in $GridContainer.get_children():
		button.rect_min_size = Vector2(button_size,button_size)
	set_process(true)


func _on_button_pressed(index):
	if board[index] != Player.NONE:
		return
	
	board[index] = current_player
	update_button_text(index)
	
	if check_winner():
		show_winner_message()
		reset_game()
	elif is_board_full():
		show_draw_message()
		reset_game()
	else:
		current_player = Player.PLAYER_O if current_player == Player.PLAYER_X else Player.PLAYER_X

func update_button_text(index):
	var button = $GridContainer.get_child(index)
	if board[index] == Player.PLAYER_X:
		button.text = "X"
	elif board[index] == Player.PLAYER_O:
		button.text = "O"
	else:
		button.text = ""

func check_winner():
	var winning_positions = [
		[0,1,2],[3,4,5],[6,7,8], #Rows
		[0,3,6],[1,4,7],[2,5,8], #Columns
		[0,4,8],[2,4,6]          #Diagonals
	]
	
	for positions in winning_positions:
		var a = board[positions[0]]
		var b = board[positions[1]]
		var c = board[positions[2]]
		
		if a != Player.NONE and a == b and b == c:
			return true
	return false

func is_board_full():
	for cell in board:
		if cell == Player.NONE:
			return false
	return true

func show_winner_message():
	var message = "Player X wins!" if current_player == Player.PLAYER_X else "Player O wins!"
	var dialog = create_dialog("winner",message)
	dialog.popup_centered()

func show_draw_message():
	var dialog = create_dialog("Draw", "It's a draw!")
	dialog.popup_centered()


func reset_game():
	board = [Player.NONE,Player.NONE,Player.NONE,
			Player.NONE,Player.NONE,Player.NONE,
			Player.NONE,Player.NONE,Player.NONE]
	for i in range(9):
		update_button_text(i)
	current_player = Player.PLAYER_X

func create_dialog(title,message):
	var dialog = AcceptDialog.new()
	dialog.window_title = title
	dialog.dialog_text = message
	add_child(dialog)
	return dialog


