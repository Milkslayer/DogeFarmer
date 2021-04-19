tool
extends TextureButton

enum STATES { 
	blocked,
	available,
	bought
}

export var upgrade_name: String
export(String, "doge_upgrade", "mod_upgrade") var type
export var enable_overlay: bool = false setget _set_overlay
export (int, 0, 100, 1) var overlay_visibility setget _set_overlay_visibility
export var price: float = 0

var upgrade_hint
var current_state: int
var hover_texture: Texture

const SETTINGS = {
	darkest_visibility = 3
}

signal buy_upgrade(upgrade_name, type, price)


func _ready():
	hover_texture = self.texture_hover

	
func _on_UpgradeBox_pressed():
	if current_state == self.STATES.available:
		emit_signal("buy_upgrade", self.upgrade_name, type, self.price)

func on_buy_upgrade_success(name):
	if name == self.upgrade_name:
		set_state(self.STATES.bought)		


func on_coins_changed(coins):
	if coins >= self.price:
		set_state(self.STATES.available)
	else:
		set_state(self.STATES.blocked)		


func set_state(state: int):
	if state == self.STATES.blocked:
		_set_overlay(true)
		self.current_state = self.STATES.blocked		
		self.texture_hover = null
		
	if state == self.STATES.available:
		_set_overlay(false)		
		self.current_state = self.STATES.available		
		self.texture_hover = hover_texture		
		
	if state == self.STATES.bought:
		self.current_state = self.STATES.bought
		self.visible = false	
		

func _set_overlay(val):
	enable_overlay = val
	self.material.set_shader_param("has_overlay", val)


func _set_overlay_visibility(val):
	overlay_visibility = val
	var visibility_normalized = float(val) / 100 if val > 0 else 0
	self.material.set_shader_param("overlay_visibility", visibility_normalized)
	
