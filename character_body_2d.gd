extends CharacterBody2D

const acceleration = 200.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var HEAVE = 100.0

func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "CharacterBody2D2":
			HEAVE -= 20
			print("Здоровье: ", HEAVE)
			if HEAVE <= 0:
				queue_free()
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		$MainCharacterAnimation.flip_h= true
		$MainCharacterAnimation.play()
	if Input.is_action_pressed("move_rigth"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		$MainCharacterAnimation.play()
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		$MainCharacterAnimation.play()
		direction.y += 1
	if Input.is_action_just_released("move_left"):
		$MainCharacterAnimation.stop()
	if Input.is_action_just_released("move_rigth"):
		$MainCharacterAnimation.stop()
	if Input.is_action_just_released("move_up"):
		$MainCharacterAnimation.stop()
	if Input.is_action_just_released("move_down"):
		$MainCharacterAnimation.stop()
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
