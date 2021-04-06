extends Control


onready var pause_overlay = $PauseOverlay

signal unpause

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pause_game():
	self.visible = true
	pause_overlay.activate_overlay()


func _on_Unpause_pressed():
	emit_signal("unpause")
	pause_overlay.disable_overlay()
	self.visible = false

func _on_Options_pressed():
	pass # Replace with function body.


func _on_SaveAndExit_pressed():
	pass # Replace with function body.
