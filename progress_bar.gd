extends ProgressBar

@export var character_body: CharacterBody3D

func _ready():
	value = 100
	max_value = 100
	min_value = 0
	show_percentage = true
	
	visible = true  # Принудительно включаем видимость
	z_index = 100   # Поднимаем поверх других элементов
	
func _process(delta):
	if character_body:
		var camera = get_viewport().get_camera_3d()
		if camera:
			var screen_pos = camera.unproject_position(character_body.global_position)
			position = screen_pos + Vector2(-size.x / 2, -30)
