extends Area2D

onready var animation_player = $AnimationPlayer
onready var coin_particles = $CoinParticles
onready var number_particles = $NumberParticles

onready var number_label = $Viewport/Label

export var coin_particles_amount: int = 1

var number_formatted_string = "+%d"

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
		
		emit_coin_particles(coin_particles_amount, event.position)
		emit_number_particles(number_formatted_string % (coin_particles_amount), event.position)

func emit_coin_particles(particle_count, position):
	var emitter = coin_particles.duplicate()
	self.add_child(emitter)
	emitter.global_position = position
	if particle_count < 10:
		emitter.amount = particle_count
	else:
		emitter.amount = 10
	emitter.init_emitter()
	
func emit_number_particles(string, position):
	var emitter = number_particles.duplicate(4)
	self.add_child(emitter)
	emitter.global_position = position
	emitter.init_emitter()
	number_label.text = string
	
	
