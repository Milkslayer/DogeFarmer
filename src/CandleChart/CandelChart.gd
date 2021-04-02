extends Node2D

@export var maxCount = 30
@export var chart_size: Vector2 = Vector2(1000., 500.)
var candles := []

var font: Font

func _ready():
	font = Font.new()
	font.add_data(load("res://NotoSansUI_Bold.ttf"))

func add_candle(c: PackedVector2Array):
	candles.push_back(c)
	if candles.size() > maxCount:
		candles.pop_front()

func _draw():
	#draw_style_box(style,Rect2(Vector2(0., 0.), chart_size))
	draw_rect(Rect2(Vector2(0., 0.), chart_size), Color.black)
	
	var max = 0 if candles.size() < 1 else candles[0][0].x
	var min = 0 if candles.size() < 1 else candles[0][0].x
	for c in candles:
		for cc in c:
			max = max(cc.x, max(cc.y, max))
			min = min(cc.x, min(cc.y, min))
	
	var delta = abs(max - min)
	var normalized = []
	for c in candles:
		var n := PackedVector2Array()
		for cc in c:
			var t = Vector2(1. - (cc.x - min)/delta, 1. - (cc.y - min)/delta)
			t = t * (chart_size.y * 0.8) + Vector2(chart_size.y * 0.1, chart_size.y * 0.1)
			n.push_back(t)
		normalized.push_back(n)
	
	draw_coords(min, max)
	
	var maxWeight = chart_size.x * 0.8
	var weight = maxWeight / (normalized.size() * 2)
	weight = max(weight, 1.)
	weight = min(weight, max(maxWeight/20., 1.))

	
	var realSize = weight * normalized.size() * 2
	
	var startX = chart_size.x * 0.1 + weight
	if maxWeight / realSize > 1.:
		startX = maxWeight - realSize  

	for i in range(normalized.size()):
		var c = normalized[i]
		var startStop = c[0]
		var maxMin = c[1]
		draw_candle(
			Vector2(startX + i * weight * 2, weight),
			Vector2(startStop.x, startStop.y),
			Vector2(maxMin.x, maxMin.y)
		)

	#draw_candle(Vector2(10., 1.), Vector2(40., 50.), Vector2(20., 70.))
	
	
func draw_candle(x: Vector2, startStop: Vector2, maxMin: Vector2 ):
	draw_line(Vector2(x.x, maxMin.x), Vector2(x.x, maxMin.y), Color.white, 1.)
	var startX = x.x - x.y/2;
	var startY = min(startStop.x, startStop.y)
	var height = max(startStop.x, startStop.y) - startY
	var color = Color.red 
	if startStop.x > startStop.y:
		color = Color.green
	draw_rect(Rect2(Vector2(startX, startY), Vector2(x.y, height)), color)

func draw_coords(minY: float, maxY: float):
	var xCount = 20 * (chart_size.x / chart_size.y)
	var xStep = chart_size.x / xCount
	for x in range(1, xCount):
		var curr = x * xStep
		draw_line(Vector2(curr, 0), Vector2(curr, chart_size.y), Color(0.5, 0.5, 0.5, 0.5), 0.2)
	
	draw_line(Vector2(0, chart_size.y * 0.9), Vector2(chart_size.x, chart_size.y * 0.9), Color(0.5, 0.5, 0.5, 0.5), 0.2)
	draw_string(font, Vector2(10, chart_size.y * 0.9), str(minY), HALIGN_FILL, 50, 14 )
	
	draw_line(Vector2(0, chart_size.y * 0.1), Vector2(chart_size.x, chart_size.y * 0.1), Color(0.5, 0.5, 0.5, 0.5), 0.2)
	draw_string(font, Vector2(10, chart_size.y * 0.1), str(maxY), HALIGN_FILL, 50, 14 )
