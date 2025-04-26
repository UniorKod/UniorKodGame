extends Area2D
@export var coin_value: int = 1  # Можно настроить разное значение для разных монет

func _ready():
	# Подключаем сигнал при касании
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name=="player":
		# Добавляем монеты к общему счёту
		Global.add_coins(coin_value)
		
		# Эффект сбора (можно заменить на анимацию)
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
		tween.tween_callback(queue_free)
		
		# Воспроизведение звука (если есть)
		if has_node("CollectSound"):
			$CollectSound.play()
