extends Node2D

export var DEBUG: bool = true

var _dogecoin_manager: DogecoinManager
var _clicker_upgrades: Array = []
var _auto_farmers: Array = []

var cps_formatted_str = "%.8f Doge/s"

onready var coin_counter_label = $GUI/CoinCounterLabel
onready var cps_label = $GUI/CoinsPerSecondLabel
onready var auto_farm_timer = $AutoFarmTimer

func _ready():
	_init_signals()
	
	_dogecoin_manager = DogecoinManager.new()
	
	_auto_farmers.append(AutoFarmer.new(1122.3,2))
	
	auto_farm_timer.start()
	
func _process(delta):
	coin_counter_label.text = str(float(_dogecoin_manager.get_coins()))
	cps_label.text = cps_formatted_str % (_calculate_cps())

func _add_dogecoins_click():
	var coins_to_add = 1
	if _clicker_upgrades.size() != 0:
		for clicker_upgrade in _clicker_upgrades:
			if clicker_upgrade.get_type() == "ClickerUpgrade":
				coins_to_add =+ clicker_upgrade.get_calculated_coins(coins_to_add)
	_dogecoin_manager.add_coins_click(coins_to_add)
	if DEBUG:
		print("Added %d coins" % (coins_to_add))


func _add_dogecoins_auto():
	if _auto_farmers.size() != 0:
		for farmer in _auto_farmers:
			if farmer.get_type() == "AutoFarmer":
				var coins_to_add = farmer.get_farmed_coins()
				_dogecoin_manager.add_coins_click(coins_to_add)
				if DEBUG:
					print("AutoFarm added %f coins" % (coins_to_add))


func _calculate_cps():
	var cps = 0
	for farmer in _auto_farmers:
			if farmer.get_type() == "AutoFarmer":
				cps += farmer.get_farmed_coins()
	return cps

func _init_signals():
	get_node("DogeClicker").connect("click", self, "_add_dogecoins_click")	


func _on_AutoFarmTimer_timeout():
	_add_dogecoins_auto()
