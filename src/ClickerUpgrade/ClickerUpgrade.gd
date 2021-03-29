extends Node

class_name ClickerUpgrade

var _click_multiplier: float = 0
var _static_upgrade: int = 0

# cpc - coins per click
func _init(multiplier, cpc):
	_click_multiplier = multiplier
	_static_upgrade = cpc
	
func _get_multiplied_clicks(coins):
	if _click_multiplier != 0:
		return coins * _click_multiplier
	return 0
	
	
func get_calculated_coins(base_coins):
	base_coins += _get_multiplied_clicks(base_coins)
	base_coins += _static_upgrade
	return base_coins


func get_type():
	return "ClickerUpgrade"
