extends Node

# Переменные для хранения максимального и текущего здоровья
var max_health: int = 100
var current_health: int = 100


# Ссылка на элемент ProgressBar
@onready var health_bar: ProgressBar = $HealthBar  # Убедитесь, что путь к ProgressBar правильный


# Функция для получения текущего здоровья
func get_health() -> int:
	return current_health

# Функция для получения максимального здоровья
func get_max_health() -> int:
	return max_health

# Функция для нанесения урона
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health < 0:
		current_health = 0
	emit_signal("health_changed", current_health)
	update_health_bar()  # Обновление состояния прогресс-бара

# Функция для сброса здоровья (например, при перезапуске игры)
func reset_health() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health)
	update_health_bar()  # Обновление состояния прогресс-бара

# Функция для обновления прогресс-бара
func update_health_bar() -> void:
	health_bar.value = current_health
	health_bar.max_value = max_health
