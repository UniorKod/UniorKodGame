extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -570.0
var HEAVE = 100.0
var can_take_damage = true
var damage_cooldown = 0.5


func _physics_process(delta: float) -> void:
	$ProgressBar.value = HEAVE
	if can_take_damage:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() is CharacterBody2D :
				main_take_damage()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim_sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("ui_left"):
		velocity.x = direction * SPEED
		anim_sprite.flip_h = true
		anim_sprite.play("default")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = direction * SPEED
		anim_sprite.flip_h = false
		anim_sprite.play("default")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_released("ui_right"):
		anim_sprite.play("idle")
	elif Input.is_action_just_released("ui_left"):
		anim_sprite.play("idle")

	move_and_slide()
	
@onready var anim_sprite = $MainCharacterAnimation
@onready var safety_timer = $SafetyTimer



var current_attack := ""
var attack_queue := ""

func main_take_damage():
	HEAVE -= 5
	print("Здоровье : ", HEAVE)
	can_take_damage = false
	$Timer.start(damage_cooldown)
	
	if HEAVE <= 0:
		queue_free()

func _ready():
	anim_sprite.stop()
	anim_sprite.frame = 0
	anim_sprite.animation_finished.connect(_on_animation_finished)
	safety_timer.timeout.connect(_on_safety_timeout)
	
	
func _input(event):
	if event.is_action_pressed("attack"):
		if current_attack == "":
			_start_attack("attack")
		else:
			attack_queue = "attack"

func _start_attack(anim_name: String):
	$SwordHitbox.enable_hitbox()
	current_attack = anim_name
	
	# Жесткий сброс анимации
	anim_sprite.stop()
	anim_sprite.frame = 0
	anim_sprite.visible = true
	
	# Настройка таймера безопасности
	var anim_length = anim_sprite.sprite_frames.get_frame_count(anim_name)
	safety_timer.start(anim_length * 0.25)  # На 50% дольше анимации
	
	# Запуск анимации
	anim_sprite.play(anim_name)
	

func _on_animation_finished():
	$SwordHitbox.disable_hitbox()
	if current_attack != "":
		_complete_attack()
		anim_sprite.play("idle")

func _on_safety_timeout():
	if current_attack != "":
		print("Анимация была принудительно остановлена по таймеру!")
		_complete_attack()

func _complete_attack():
	# Гарантированная остановка
	anim_sprite.stop()
	anim_sprite.frame = 0
	modulate = Color.WHITE
	
	# Обработка очереди атак
	if attack_queue != "":
		var next_attack = attack_queue
		attack_queue = ""
		_start_attack(next_attack)
	else:
		current_attack = ""
		anim_sprite.play("idle")
		


func _on_timer_timeout() -> void:
	can_take_damage = true
