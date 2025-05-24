extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.is_climbing = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.is_climbing = false
