extends Node2D

signal reset_game

var tail = preload("res://Tail.tscn")
var food = preload("res://Food.tscn")

var next_dir : Vector2
var tail_length : int

func spawn_food():
	var _food = food.instance()
	add_child(_food)
	_food.connect("food_was_eaten", self, "_on_Food_was_eaten")
	self.connect("reset_game", _food, "queue_free")
	
func _on_Food_was_eaten():
	tail_length += 1
	call_deferred("spawn_food")

func _on_Timer_timeout():
	var prev_snake_pos = $Snake.position
	if $Snake.move_to(next_dir):
		var _tail = tail.instance()
		add_child(_tail)
		_tail.set_position(prev_snake_pos)
		$Timer.connect("timeout", _tail, "_on_Timer_timeout")
		self.connect("reset_game", _tail, "queue_free")
	else:
		stop_game()
	
func _input(event):
	if event.is_action_pressed("ui_up"): next_dir = Vector2 (0, -32)
	if event.is_action_pressed("ui_down"): next_dir = Vector2 (0, 32) 
	if event.is_action_pressed("ui_left"): next_dir = Vector2 (-32, 0)
	if event.is_action_pressed("ui_right"): next_dir = Vector2 (32, 0)
	
	if event.is_action_pressed("ui_accept") and $Timer.is_stopped():
		 start_game()

func start_game():
	$Menu.hide()
	emit_signal("reset_game")
	$Snake.position = Vector2 (128, 128)
	$Snake.cur_dir = Vector2 (32, 0)
	next_dir = Vector2 (32, 0)
	tail_length = 3
	$Timer.start()
	for n in range (3): spawn_food()

func stop_game():
	$Timer.stop()
	$Menu/Label.text = "Game Over\n\nPress space bar to restart"
	$Menu.show()
