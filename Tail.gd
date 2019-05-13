extends StaticBody2D

var cur_pos = 1

func _on_Timer_timeout():
	cur_pos += 1
	if cur_pos > get_parent().tail_length: queue_free()