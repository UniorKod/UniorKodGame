extends CharacterBody2D

# Здоровье врага
var enemy_health: int = 100  # Переименовано из vrag_heave для читаемости
var speed: float = 200
var gravity: float = 980
var floor_check_distance: float = 20
var is_on_floor: bool = false
var fixed_y_position: float
var player: Node2D

# RayCast для проверки пола (создаётся один раз)
var floor_ray: RayCast2D

func _ready():
	player = get_tree().get_first_node_in_group("Главный")
	fixed_y_position = position.y
	
	# Инициализируем RayCast один раз
	floor_ray = RayCast2D.new()
	floor_ray.target_position = Vector2(0, floor_check_distance)
	add_child(floor_ray)

func _physics_process(delta):
	if not player:
		return
	
	check_floor_status()
	
	# Горизонтальное движение к игроку
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	
	# Вертикальное движение (гравитация)
	if not is_on_floor:
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Останавливаем падение, если на полу
	
	move_and_slide()

# Проверка, стоит ли враг на поверхности
func check_floor_status():
	floor_ray.force_raycast_update()
	is_on_floor = floor_ray.is_colliding()

# Получение урона
func take_damage(damage: int, knockback_direction: Vector2):
	velocity = knockback_direction.normalized() * 500  # Отбрасывание при ударе
	enemy_health -= damage
	print("Здоровье врага: ", enemy_health)
	if enemy_health <= 0:
		queue_free()  # Уничтожаем врага при смерти
