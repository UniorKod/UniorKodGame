extends Area2D

func _ready():
	# Подключаем сигнал через Callable (Godot 4.x)
	body_entered.connect(_on_body_entered)  # <- передаём функцию, а не строку!

func _on_body_entered(body: Node):
	if body.name == "Главный":
		get_tree().change_scene_to_file("res://Game3Level.tscn")
