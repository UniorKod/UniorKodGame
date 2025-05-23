extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


@onready var anim_sprite = $SwordHitbox/AnimatedSprite2D
@onready var safety_timer = $Timer
@onready var animated_sprite = $SwordHitbox/AnimatedSprite2D


var current_attack := ""
var attack_queue := ""


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
		animated_sprite.play("idle")

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
		
