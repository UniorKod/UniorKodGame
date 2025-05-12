extends CharacterBody2D

# Настройки здоровья
@export var max_health := 100.0
var current_health: float

# Эффекты при уроне/смерти
@export var hurt_animation_duration := 0.3  # Длительность мигания при уроне
@export var death_effect: PackedScene       # Префаб эффекта смерти (например, взрыв)

# Ссылки на ноды
@onready var sprite := $Sprite2D            # Замените на ваш спрайт/анимацию
@onready var hitbox := $Hitbox/CollisionShape2D  # Зона Hitbox для получения урона
var follow_speed: float = 200.0
var target: Node2D
func _ready():
	
	# Найдите целевой объект по имени
	target = get_node("../Target")  # Убедитесь, что путь к целевому объекту правильный

func _process(delta):
	if target:
		# Вычисляем направление к целевому объекту
		var direction = (target.position - position).normalized()
		
		# Двигаем объект в направлении целевого объекта
		position += direction * follow_speed * delta
	if target:
		# Вычисляем направление к целевому объекту
		var direction = (target.position - position).normalized()
		
		# Двигаем объект в направлении целевого объекта
		position += direction * follow_speed * delta

	if target:
		# Вычисляем направление к целевому объекту
		var direction = (target.position - position).normalized()
		
		# Двигаем объект в направлении целевого объекта
		position += direction * follow_speed * delta

	current_health = max_health
	update_health_ui()  # Если есть UI здоровья

func take_damage(damage: float):
	if current_health <= 0:
		return  # Персонаж уже мертв
	
	current_health -= damage
	print("", current_health)
	
	# Визуальная обратная связь (мигание)
	_play_hurt_animation()
	
	# Проверка смерти
	if current_health <= 0:
		die()
	else:
		update_health_ui()


func die():
	print("Босс умер!")
	set_physics_process(false)  # Отключаем физику
	hitbox.set_deferred("disabled", true)  # Отключаем хитбокс
	
	# Спавним эффект смерти (если есть префаб)
	if death_effect:
		var effect = death_effect.instantiate()
		effect.global_position = global_position
		get_parent().add_child(effect)
	
	queue_free()  # Удаляем персонажа (или вызываем respawn)

func _play_hurt_animation():
	# Мигание спрайта (белый цвет)
	sprite.modulate = Color.RED
	await get_tree().create_timer(hurt_animation_duration).timeout
	sprite.modulate = Color.WHITE

func update_health_ui():
	# Если есть UI (например, ProgressBar)
	if has_node("HealthBar"):
		$"HealthBar".value = current_health / max_health * 100
