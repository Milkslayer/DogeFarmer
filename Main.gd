extends Node2D

var _dogecoin_manager: DogecoinManager
var _clicker_upgrades: Array = []
var _auto_farmers: Array = []

onready var coin_label = $GUI/CoinLabel
onready var auto_farm_timer = $AutoFarmTimer

func _ready():
	get_node("DogeClicker").connect("click", self, "_add_dogecoins_click")
	
	_dogecoin_manager = DogecoinManager.new()
	var farmer = AutoFarmer.new(10, 1)
	var farmer2 = AutoFarmer.new(0.3, 3)
	_auto_farmers.append(farmer)
	_auto_farmers.append(farmer2)
	
	auto_farm_timer.start()
	
func _process(delta):
	coin_label.text = _dogecoin_manager.get_label_string()


func _add_dogecoins_click():
	var coins_to_add = 1
	if _clicker_upgrades.size() != 0:
		for clicker_upgrade in _clicker_upgrades:
			if clicker_upgrade.get_type() == "ClickerUpgrade":
				coins_to_add =+ clicker_upgrade.get_calculated_coins(coins_to_add)
	_dogecoin_manager.add_coins_click(coins_to_add)
	print("Added %d coins" % (coins_to_add))

func _add_dogecoins_auto():
	if _auto_farmers.size() != 0:
		for farmer in _auto_farmers:
			if farmer.get_type() == "AutoFarmer":
				var coins_to_add = farmer.get_farmed_coins()
				_dogecoin_manager.add_coins_click(coins_to_add)
				print("AutoFarm added %f coins" % (coins_to_add))
				
func _on_AutoFarmTimer_timeout():
	_add_dogecoins_auto()
