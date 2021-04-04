extends Node2D

export var DEBUG: bool = true

const GAME_STATES = {active = 0, paused = 1}

var current_state: int
var _dogecoin_manager: DogecoinManager
var _clicker_upgrades: Array = []
var _auto_farmers: Array = []

var cps_formatted_str = "%.8f Doge/s"

onready var coin_counter_label = $GUI/LeftSection/CoinCounterLabel
onready var cps_label = $GUI/LeftSection/CoinsPerSecondLabel
onready var auto_farm_timer = $AutoFarmTimer
onready var scrolling_bg = $GUI/Background/ScrollingBackground
onready var pause_screen = $GUI/PauseScreen

signal pause

func _ready():
	_init_signals()
	
	_dogecoin_manager = DogecoinManager.new()
	
	auto_farm_timer.start()
	
	current_state = GAME_STATES.active
	
func _process(_delta):
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
		print("[INFO] Added %d coins" % (coins_to_add))


func _add_dogecoins_auto():
	if _auto_farmers.size() != 0:
		for farmer in _auto_farmers:
			if farmer.get_type() == "AutoFarmer":
				var coins_to_add = farmer.get_farmed_coins()
				_dogecoin_manager.add_coins_click(coins_to_add)
				if DEBUG:
					print("[INFO] AutoFarm added %f coins" % (coins_to_add))


func _calculate_cps():
	var cps = 0
	for farmer in _auto_farmers:
			if farmer.get_type() == "AutoFarmer":
				cps += farmer.get_farmed_coins()
	return cps

# Signals

func _init_signals():
	get_node("GUI/DogeClicker").connect("click", self, "_on_DogeClick_pressed")	
	get_node("GUI/PauseScreen").connect("unpause", self, "_on_game_unpause")
	self.connect("pause", pause_screen, "pause_game")
	
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
		
# Signals end



