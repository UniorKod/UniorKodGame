extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -570.0
var HEAVE = 100.0


func _physics_process(delta: float) -> void:
	$ProgressBar.value = HEAVE
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is CharacterBody2D :
			HEAVE -= 5
			print("Здоровье : ", HEAVE)
			if HEAVE <= 0:
				queue_free()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
