extends Particles2D


onready var timer = $Timer

func init_emitter():
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	self.emitting = true


func _on_timer_timeout():
	if !self.emitting:
		self.queue_free()
