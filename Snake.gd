extends KinematicBody2D

var cur_dir: Vector2

func move_to(next_dir) -> bool:
	if next_dir + cur_dir != Vector2.ZERO: cur_dir = next_dir
	var coll_object = move_and_collide (cur_dir)
	return !is_instance_valid(coll_object)