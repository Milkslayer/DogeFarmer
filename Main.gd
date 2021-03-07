extends Node2D

var _dogecoin_manager: DogecoinManager
onready var coin_label = $CoinLabel


func _ready():
	get_node("DogeClicker").connect("click", self, "_add_dogecoins")
	
	_dogecoin_manager = DogecoinManager.new()
	
	
func _process(delta):
	$CoinLabel.text = _dogecoin_manager.get_label_string()


func _add_dogecoins():
	_dogecoin_manager.add_coins(1)
