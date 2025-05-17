extends CharacterBody2D

@export var gravity: float = 9800.0	
@export var max_speed: float = 200.0
@export var acceleration: float = 5.0
@export var stop_distance: float = 50.0
@export var floor_check_distance: float = 10.0
var player: CharacterBody2D
var speed = 100
var fixed_y_position: float = 0.0
var is_on_floor: bool = false
var vrag_heave = 100.0


func check_floor_status():
	# Создаем временный RayCast для проверки пола
	var ray = RayCast2D.new()
	ray.target_position = Vector2(0, floor_check_distance)
	add_child(ray)
	ray.force_raycast_update()
	
	is_on_floor = ray.is_colliding()
	ray.queue_free()

func _ready():
	player = get_tree().get_first_node_in_group("Главный")
	fixed_y_position = position.y

func _physics_process(delta):
	if not player:
		return
	check_floor_status()
	if not is_on_floor:

		velocity.y += gravity * delta
	move_and_slide()
	check_floor_status()
	var distance = global_position.distance_to(player.global_position)
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	
	#position.y = fixed_y_position
	velocity.y = 0
	move_and_slide()
func take_damage(damage: int, direction: Vector2):
	velocity = direction.normalized()
	vrag_heave -= 0.1
	$ProgressBar.value = vrag_heave
	print("Здоровье врага: ", vrag_heave)
	if vrag_heave <= 0:
		queue_free()
