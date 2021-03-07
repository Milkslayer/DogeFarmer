extends Node

class_name DogecoinManager

var _dogecoins: int = 0

var _dogecoin_label_string = "Dogecoins %s"

func add_coins(coins):
	_dogecoins += coins
	
func spend_coins(coins):
	_dogecoins -= coins
	
func get_coins():
	return _dogecoins
	
func get_label_string():
	return _dogecoin_label_string % (_dogecoins)
