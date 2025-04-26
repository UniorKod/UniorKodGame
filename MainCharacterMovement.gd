extends CharacterBody2D

const acceleration = 200.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var velosity = 100.0

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_rigth"):
		direction.x += 1
	if Input.is_action_pressed("move_up") and $".".position.y > :
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	# Add the gravity.
	if direction.length() > 0:
		direction = direction.normalized()
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	velocity = direction * SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()
