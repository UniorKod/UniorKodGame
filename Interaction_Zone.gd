extends Area2D

@export var bridge_node: NodePath = "../Bridge"
@onready var bridge = get_node(bridge_node)
@onready var prompt_label = $Label

var player_in_zone: bool = false

func _ready():
	prompt_label.text = "Press [E] to lower bridge"
	prompt_label.hide()
	
	# Настройки текста
	prompt_label.add_theme_font_size_override("font_size", 20)
	prompt_label.add_theme_color_override("font_outline_color", Color.BLACK)
	prompt_label.add_theme_constant_override("outline_size", 2)

func _on_body_entered(body: CharacterBody2D):
	if body.name == "Player":
		player_in_zone = true
		prompt_label.show()

func _on_body_exited(body: CharacterBody2D):
	if body.name == "Player":
		player_in_zone = false
		prompt_label.hide()

func _input(event):
	if player_in_zone and event.is_action_pressed("Press_E"):
		bridge.fall()
		prompt_label.hide()
		set_process_input(false)
