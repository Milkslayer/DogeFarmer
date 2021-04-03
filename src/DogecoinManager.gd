extends Node

class_name DogecoinManager

var _dogecoins: float = 0

var _dogecoin_debug_string = "Dogecoins %s"

func add_coins_click(coins):
	_dogecoins += coins
	
func spend_coins(coins):
	_dogecoins -= coins
	
func get_coins():
	return _dogecoins
	
func get_debug_string():
	return _dogecoin_debug_string % (_dogecoins)
