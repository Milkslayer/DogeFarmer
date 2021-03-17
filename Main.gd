extends Node2D

var _dogecoin_manager: DogecoinManager
var _clicker_upgrades: Array = []

onready var coin_label = $GUI/CoinLabel


func _ready():
	get_node("DogeClicker").connect("click", self, "_add_dogecoins")
	
	_dogecoin_manager = DogecoinManager.new()
	
	
func _process(delta):
	coin_label.text = _dogecoin_manager.get_label_string()


func _add_dogecoins():
	var coins_to_add = 1
	if _clicker_upgrades.size() != 0:
		for clicker_upgrade in _clicker_upgrades:
			if clicker_upgrade.get_type() == "ClickerUpgrade":
				coins_to_add =+ clicker_upgrade.get_calculated_coins(coins_to_add)
	_dogecoin_manager.add_coins(coins_to_add)
	print("Added %d coins" % (coins_to_add))
