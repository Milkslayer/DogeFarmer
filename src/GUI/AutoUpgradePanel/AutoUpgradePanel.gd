tool
extends Panel

enum STATES {
	blocked = 0, 
	unblocked = 1,
}

export var texture_normal: Texture
export var price: float
export var amount: int = 0 setget set_amount
export var title: String
export var doge_per_sec: float = 0
export var blocked: bool = true
export var discovered: bool = false

onready var button = $Button
onready var amount_label = $AmountLabel
onready var price_label = $PriceLabel
onready var title_label = $TitleLabel
onready var blocker_overlay = $Blocker

var price_formatted_string = "%.3f Doge"
var amount_formatted_string = "x%d"
var undiscovered_placeholder = "???"

var upgrade_name: String
var upgrade_hint: String

var blocked_label_color: Color = Color(1, 0, 0, 1)
var unblocked_label_color: Color = Color(1, 1, 1, 1)

signal buy_auto_upgrade(name, type, price, dps)

func _ready():
	amount_label.text = amount_formatted_string % (amount)
	price_label.text = price_formatted_string % (price)
	title_label.text = title
	
	if texture_normal != null:
		button.texture_normal = texture_normal

	upgrade_name = title
	upgrade_hint = self.hint_tooltip

	if !discovered:
		title_label.text = undiscovered_placeholder
		self.hint_tooltip = undiscovered_placeholder
		amount_label.visible = false
		blocked = true
		
	if blocked:
		set_state(STATES.blocked)
	else:
		set_state(STATES.unblocked)
		
	
			

func on_buy_upgrade_success(name):
	if name == upgrade_name:
		if !discovered:
			amount_label.visible = true
			title_label.text = upgrade_name
			self.hint_tooltip = upgrade_hint
			
			discovered = true
		set_amount(amount + 1)
		amount_label.text = amount_formatted_string % (amount)
		

func _on_Button_pressed():
	emit_signal("buy_auto_upgrade", title, "auto_farmer", price, doge_per_sec)


func on_coins_changed(coins):
	if price > coins:
		set_state(STATES.blocked)
	elif price <= coins:
		set_state(STATES.unblocked)


func set_state(state: int):
	if state == STATES.blocked:
		blocker_overlay.visible = true
		price_label.add_color_override("font_color", blocked_label_color)
	elif state == STATES.unblocked:
		blocker_overlay.visible = false
		price_label.add_color_override("font_color", unblocked_label_color)


func set_amount(value: int):
	amount = value
	property_list_changed_notify()

