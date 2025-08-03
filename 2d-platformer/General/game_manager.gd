extends Node

var coins: int = 0

func add_coin():
	coins += 1
	
func get_coin_count_string():
	return " × " + str(coins)
