extends ColorRect


onready var animation_player = $AnimationPlayer


func activate_overlay():
	animation_player.play("EaseIn")
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	

func disable_overlay():
	self.color.a = 0
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
