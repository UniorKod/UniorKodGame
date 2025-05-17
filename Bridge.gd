extends StaticBody2D


@export var fall_duration: float = 1.5
var is_fallen: bool = false
var initial_collision_size: Vector2

func _ready():
	var sprite = $Marker2D/Sprite2D
	var collision = $CollisionShape2D
	
	if sprite.texture && collision.shape is RectangleShape2D:
		# Сохраняем начальный размер
		initial_collision_size = Vector2(
			sprite.texture.get_width() * sprite.scale.x,
			sprite.texture.get_height() * sprite.scale.y
		)
		
		# Настраиваем коллизию
		collision.shape.size = initial_collision_size
		collision.position = Vector2(-sprite.position.x/2, -sprite.position.y) #+ $Marker2D.position
	# Убедимся, что структура сцены правильная
	if not has_node("Marker2D/Sprite2D"):
		push_error("Требуется структура: Pivot (Node2D) → BridgeVisual (Sprite2D)")
		return
	
	# Центрируем визуал относительно точки вращения
	$Marker2D/Sprite2D.position = Vector2(0, $Marker2D/Sprite2D.position.y)

func fall():
	if is_fallen: return
	
	var sprite = $Marker2D/Sprite2D
	var collision = $CollisionShape2D
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	var sprite_height = $Marker2D/Sprite2D.texture.get_height()
	var sprite_width = $Marker2D/Sprite2D.texture.get_width()
	
	# Вращаем вокруг точки Pivot
	tween.tween_property($Marker2D, "rotation_degrees", -90.0, fall_duration)
	
	# Корректируем коллизию
	if $CollisionShape2D.shape is RectangleShape2D:
		var new_size = Vector2(
			initial_collision_size.y,
			initial_collision_size.x
		)
		
		var new_position = Vector2(
			$Marker2D.position.x - initial_collision_size.y/2,
			$Marker2D.position.y + initial_collision_size.x/2
		)
		
		tween.parallel().tween_property($CollisionShape2D.shape, "size", new_size, fall_duration)
		tween.parallel().tween_property($CollisionShape2D, "position", 
		new_position,#visual_node.texture.get_height()*3.75), 
		fall_duration)
	
	is_fallen = true
