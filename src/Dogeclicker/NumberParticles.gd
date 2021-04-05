extends Particles2D


onready var timer = $Timer
onready var label = $Viewport/Label
onready var viewport = $Viewport

export var label_text: String = "+-"

func init_emitter():
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	self.emitting = true


func _on_timer_timeout():
	if !self.emitting:
		self.queue_free()
