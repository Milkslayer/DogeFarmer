tool
extends ScrollContainer


onready var v_container = $UpgradesVContainer

func _ready():
	if v_container.get_child_count() >= 5:
		self.get_stylebox("bg").content_margin_bottom = 120
	else:
		self.get_stylebox("bg").content_margin_bottom = -1
		

