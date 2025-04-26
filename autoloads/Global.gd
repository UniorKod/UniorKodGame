extends Node
# Сигнал, который будет вызываться при изменении количества монет
signal coins_updated(new_amount, change_amount)

var label: Label

# Переменная для хранения количества монет с сеттером
var coins: int = 0:
	set(value):
		# Вычисляем разницу между новым и старым значением
		var difference = value - coins
		coins = value
		# Отправляем сигнал с новым значением и разницей
		coins_updated.emit(coins, difference)
		# Сохраняем значение (реализацию save_coins см. ниже)
		save_coins()
func get_player():
	return get_tree().get_first_node_in_group("player")
func get_ui():
	return get_node("/root/Node2D/Label")# Абсолютный путь

# Добавление монет
func add_coins(amount: int):
	coins += amount  # Здесь автоматически вызовется setter
	print(coins)
	label = get_ui()
	label.text = "Количество монет " + str(coins)

# Сброс счёта
func reset_coins():
	coins = 0  # Здесь тоже вызовется setter

# Сохранение монет
func save_coins():
	var save_data = {
		"coins": coins,
		"last_updated": Time.get_datetime_string_from_system()
	}
	var save_path = "user://game_save.dat"
	
	# Используем FileAccess для сохранения
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
	else:
		push_error("Failed to save coins: %s" % FileAccess.get_open_error())

# Загрузка монет
func load_coins():
	var save_path = "user://game_save.dat"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			coins = save_data.get("coins", 0)
		else:
			push_error("Failed to load coins: %s" % FileAccess.get_open_error())

# Вызывается при загрузке скрипта
func _ready():
	load_coins()
	print("Loaded coins: ", coins)
	var score: int = 0


	
