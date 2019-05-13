extends Area2D

signal food_was_eaten

func _ready():
	set_position(Vector2(rand_range(48, 977), rand_range(48, 561)).snapped(Vector2(32, 32)))

func _on_Food_body_entered(body):
	if body.name == "Snake":
		emit_signal("food_was_eaten")
		call_deferred("queue_free")
	else:
		# falsch positioniert
		set_position(Vector2(rand_range(48, 977), rand_range(48, 561)).snapped(Vector2(32, 32)))
