extends Area2D

onready var animation_player = $AnimationPlayer
onready var coin_particles = $CoinParticles

var coin_particles_amount: int = 1

signal click

func _ready():
	pass # Replace with function body.


func set_coin_particles_amount(amount: int):
	coin_particles_amount = amount


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		emit_signal("click")
		animation_player.stop()
		animation_player.play("Click")
		
		if coin_particles.amount != coin_particles_amount:
			coin_particles.amount = coin_particles_amount
		
		coin_particles.emitting = true
