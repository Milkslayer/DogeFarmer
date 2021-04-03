tool
extends TextureRect

export var pause_scrolling: bool = true

var bg_offset = 0



func _process(delta):
	if not pause_scrolling:
		material.set_shader_param('time', bg_offset);
		bg_offset += 0.01
