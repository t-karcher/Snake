extends Node2D

var tail = preload("res://Tail.tscn")

var snake_dir : Vector2
var next_dirs = []
var prev_pos : Vector2
var tail_nodes = []

func _on_Timer_timeout():
	var next_dir : Vector2 = snake_dir
	while next_dirs.size() > 0 and next_dir == snake_dir:
		next_dir = next_dirs.pop_front()
	if next_dir + snake_dir != Vector2.ZERO: snake_dir = next_dir
	prev_pos = $Snake.position
	if !is_instance_valid($Snake.move_and_collide (snake_dir)):
		if tail_nodes.size() > 0:
			tail_nodes.push_front(tail_nodes.pop_back())
			tail_nodes[0].set_position(prev_pos)
	else:
		stop_game()
	
func _input(event):
	if event.is_action_pressed("ui_accept") and $Timer.is_stopped():
		 start_game()
	if event.is_action_pressed("ui_up"): next_dirs.append (Vector2 (0, -32))
	if event.is_action_pressed("ui_down"): next_dirs.append (Vector2 (0, 32)) 
	if event.is_action_pressed("ui_left"): next_dirs.append (Vector2 (-32, 0))
	if event.is_action_pressed("ui_right"): next_dirs.append (Vector2 (32, 0))

func start_game():
	$Snake.set_position (Vector2 (128, 128))
	snake_dir = Vector2 (32, 0)
	next_dirs.clear()
	for n in tail_nodes: n.queue_free()
	tail_nodes.clear()
	$Food.set_position(Vector2(rand_range(48, 977), rand_range(48, 561)).snapped(Vector2(32, 32)))
	$Food/Label.text = "1"
	$Menu.hide()
	$Timer.start()

func stop_game():
	$Timer.stop()
	$Menu/Label.text = "Game Over\n\nPress space bar to restart"
	$Menu.show()
	
func _on_Food_body_entered(body):
	if body == $Snake:
		tail_nodes.append(tail.instance())
		call_deferred("add_child", tail_nodes[-1])
		$Food/Label.text = str(tail_nodes.size() + 1)
	$Food.set_position(Vector2(rand_range(48, 977), rand_range(48, 561)).snapped(Vector2(32, 32)))

