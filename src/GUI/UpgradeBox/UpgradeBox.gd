tool
extends TextureButton

export(String, "doge_upgrade", "mod_upgrade") var type
export var enable_overlay: bool = false setget set_overlay
export (int, 0, 100, 1) var overlay_visibility setget set_overlay_visibility

var upgrade_name: String
var upgrade_hint
var price

signal buy_upgrade(upgrade_name, type, price)


func _ready():
	pass

func _on_UpgradeBox_pressed():
	emit_signal("buy_upgrade", self.upgrade_name, self.type, self.price)


func on_buy_upgrade_success(name):
	pass


func on_coins_changed(coins):
	pass


func set_overlay(val):
	enable_overlay = val
	self.material.set_shader_param("has_overlay", val)


func set_overlay_visibility(val):
	overlay_visibility = val
	var visibility_normalized = float(val) / 100 if val > 0 else 0
	self.material.set_shader_param("overlay_visibility", visibility_normalized)
	
