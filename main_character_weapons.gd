extends Node2D


@onready var animated_sprite =$player/SwordHitbox/AnimatedSprite2D
var can_attack := true

func _input(event):
	if event.is_action_pressed("attack") and can_attack:
		start_attack_animation()

func start_attack_animation():
	can_attack = false
	
	# Сброс и запуск анимации
	
	animated_sprite.stop()
	animated_sprite.frame = 0
	animated_sprite.play("attack")
	
	# Ждем завершения анимации
	await animated_sprite.animation_finished
	can_attack = true

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		can_attack = true
