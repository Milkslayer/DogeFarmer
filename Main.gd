extends Node2D

export var DEBUG: bool = true

const GAME_STATES = {active = 0, paused = 1}

var current_state: int
var _dogecoin_manager: DogecoinManager
var _clicker_upgrades: Array = []
var _auto_farmers: Dictionary = {}

var cps_formatted_str = "%.3f Doge/s"

onready var coin_counter_label = $GUI/LeftSection/CoinCounterLabel
onready var cps_label = $GUI/LeftSection/CoinsPerSecondLabel
onready var auto_farm_timer = $AutoFarmTimer
onready var scrolling_bg = $GUI/Background/ScrollingBackground
onready var pause_screen = $GUI/PauseScreen
onready var doge_clicker = $GUI/DogeClicker
onready var auto_upgrades_container = $GUI/RightSection/TabContainer/Farming/ScrollContainer/UpgradesVContainer
onready var doge_upgrades_container = $GUI/RightSection/TabContainer/Upgrades/Wrapper/UpgradesShop/ScrollContainer/UpgradesHContainer
onready var mod_upgrades_container = $GUI/RightSection/TabContainer/Upgrades/Wrapper/UpgradesShop/ScrollContainer/UpgradesHContainer

signal pause
signal buy_upgrade_success(upgrade_name)

func _ready():
	_dogecoin_manager = DogecoinManager.new()
	auto_farm_timer.start()
	current_state = GAME_STATES.active
	
	_init_signals()
	
	
func _process(_delta):
	coin_counter_label.text = str(float(_dogecoin_manager.get_coins()))
	cps_label.text = cps_formatted_str % (_calculate_cps())


func _add_dogecoins_click():
	var coins_to_add = 1
	if _clicker_upgrades.size() != 0:
		for clicker_upgrade in _clicker_upgrades:
			if clicker_upgrade.get_type() == "ClickerUpgrade":
				coins_to_add =+ clicker_upgrade.get_calculated_coins(coins_to_add)
	_dogecoin_manager.add_coins(coins_to_add)
	doge_clicker.set_coin_particles_amount(coins_to_add)
	if DEBUG:
		print("[INFO] Click added %d coins" % (coins_to_add))


func _add_dogecoins_auto():
	if _auto_farmers.size() != 0:
		for key in _auto_farmers:
			if _auto_farmers[key].get_type() == "AutoFarmer":
				var coins_to_add = float(_auto_farmers[key].get_farmed_coins())
				_dogecoin_manager.add_coins(coins_to_add)
				if DEBUG:
					print("[INFO] %s added %f coins" % [key, coins_to_add])


func _calculate_cps():
	var cps = 0
	for farmer in _auto_farmers.values():
			if farmer.get_type() == "AutoFarmer":
				cps += farmer.get_farmed_coins()
	return cps

# Signals

func _init_signals():
	get_node("GUI/DogeClicker").connect("click", self, "_on_DogeClick_pressed")	
	get_node("GUI/PauseScreen").connect("unpause", self, "_on_game_unpause")
	self.connect("pause", pause_screen, "pause_game")
	
#	Initiate all auto upgrades
	for upgrade_element in auto_upgrades_container.get_children():
		upgrade_element.connect("buy_auto_upgrade", self, "_on_buy_auto_upgrade")
		self.connect("buy_upgrade_success", upgrade_element, "on_buy_upgrade_success")
		_dogecoin_manager.connect("coins_changed", upgrade_element, "on_coins_changed")
	
#	Initate all doge and mod upgrades
	for upgrade_element in doge_upgrades_container.get_children():
		pass
		
	for upgrade_element in mod_upgrades_container.get_children():
		pass	
	
func _on_AutoFarmTimer_timeout():
	_add_dogecoins_auto()
	
	
func _on_MenuButton_pressed():
	emit_signal("pause")
	current_state = GAME_STATES.paused
	scrolling_bg.pause_scrolling = true
	if DEBUG:
		print("[INFO] Game state set to PAUSED")
		
func _on_DogeClick_pressed():
	_add_dogecoins_click()
	
func _on_game_unpause():
	current_state = GAME_STATES.active
	scrolling_bg.pause_scrolling = false
	if DEBUG:
		print("[INFO] Game state set to ACTIVE")


func _on_buy_auto_upgrade(name, type, price, doge_per_sec):
	if price <= _dogecoin_manager.get_coins():
		if type == "auto_farmer":
			if _auto_farmers.has(name):
				_auto_farmers[name].add_farmer()
			else:
				_auto_farmers[name] = AutoFarmer.new(doge_per_sec, 1)
		_dogecoin_manager.spend_coins(price)
		emit_signal("buy_upgrade_success", name)
		if DEBUG:
			print("[INFO] Bought upgrade %s for %f of type %s giving %f doge per tick" % [name, price, type, doge_per_sec])

# Signals end



