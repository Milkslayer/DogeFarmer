extends Node


class_name AutoFarmer


var coins_per_tick: float
var multiplier: float

func _init(cpt: float, count: float):
	coins_per_tick = cpt
	multiplier = count

	
func get_farmed_coins():
	return coins_per_tick * multiplier


func get_type():
	return "AutoFarmer"


func add_farmer():
	multiplier += 1
