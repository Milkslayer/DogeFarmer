extends Node


class_name AutoFarmer


var coins_per_tick: float
var multiplier: int

func _init(cpt: float, count: int):
	coins_per_tick = cpt
	multiplier = count
	
func get_farmed_coins():
	return coins_per_tick * float(multiplier)


func get_type():
	return "AutoFarmer"
