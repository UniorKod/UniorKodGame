extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -570.0
var HEAVE = 100.0

# Получаем ссылку на AnimatedSprite2D
@onready var animated_sprite = $MainCharacterAnimation

func _physics_process(delta: float) -> void:
	$ProgressBar.value = HEAVE
	
	# Обработка столкновений
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is CharacterBody2D:
			HEAVE -= 5
			print("Здоровье : ", HEAVE)
			if HEAVE <= 0:
				get_tree().change_scene_to_file("res://DieScene.tscn")
				queue_free()
	
	# Гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Прыжок
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")  # Анимация прыжка
	
	# Движение влево/вправо
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		# Поворот спрайта в направлении движения
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Воспроизведение анимации бега, если персонаж на земле
		if is_on_floor():
			animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Анимация idle, если персонаж на земле и не двигается
		if is_on_floor():
			animated_sprite.play("idle")
	
	
	move_and_slide()
