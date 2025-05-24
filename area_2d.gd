extends Area2D

@export var damage := 10
@export var knockback := 800
@export var check_interval := 0.1  # Интервал проверки в секундах
var _timer := 0.0
var can_damage := true
var objects_in_zone := []  # Массив для отслеживания уже обработанных врагов


	
func _ready():
	monitoring = true
	#monitoring = true
	#collision_layer = 2  # Слой оружия
	#collision_mask = 4   # Слой врагов
	#
	## Включаем постоянный мониторинг
	#monitorable = true
	


func enable_hitbox():
	can_damage = true
	monitoring = true # Очищаем массив при каждом новом включении

func disable_hitbox():
	monitoring = false


func _on_body_exited(body):
	if body in objects_in_zone:
		objects_in_zone.erase(body)
		print("Вышел:", body.name)

func _process(delta):
	 #Получаем все тела в зоне
	for body in objects_in_zone:
		if is_instance_valid(body) and body.has_method("take_damage") and Input.is_action_just_pressed("attack"):
			var direction = (body.global_position - global_position).normalized()
			body.take_damage(damage, direction * knockback)
			
		
	
func process_in_area(delta):
	# Этот метод будет вызываться каждый кадр, пока объект в зоне
	print("Нахожусь в зоне! Время: ", delta)



func _on_body_entered(body: Node2D) -> void:
	if not body in objects_in_zone:
		objects_in_zone.append(body)
		print("Вошел:", body.name)
