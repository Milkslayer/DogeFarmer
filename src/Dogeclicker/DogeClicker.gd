extends Area2D

onready var animation_player = $AnimationPlayer

signal click

func _ready():
	pass # Replace with function body.

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event .is_pressed():
		emit_signal("click")
		animation_player.stop()
		animation_player.play("Click")
