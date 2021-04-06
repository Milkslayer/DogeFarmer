extends Node

class_name DogecoinManager

var _dogecoins: float = 0

var _dogecoin_debug_string = "Dogecoins %s"

signal coins_changed(current_coins)

func add_coins(coins):
	_dogecoins += coins
	emit_signal("coins_changed", get_coins())
	
func spend_coins(coins):
	_dogecoins -= coins
	emit_signal("coins_changed", get_coins())
	
func get_coins():
	return _dogecoins
	
func get_debug_string():
	return _dogecoin_debug_string % (_dogecoins)
