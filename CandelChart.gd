extends Node2D

var chart_size: Vector2 = Vector2(1000., 500.)
var candles := [
	#PackedVector2Array([Vector2(3410., 1820.), Vector2(4124., 1208.)]),
	#PackedVector2Array([Vector2(2012., 1231.), Vector2(4124., 1208.)]),
	#PackedVector2Array([Vector2(1251., 1501.), Vector2(4124., 1208.)]),
	#PackedVector2Array([Vector2(1315., 1412.), Vector2(4124., 1208.)]),
	#PackedVector2Array([Vector2(1411., 1215.), Vector2(4124., 1208.)]),
	#PackedVector2Array([Vector2(1212., 1251.), Vector2(4124., 1208.)])
]

var maxCount = 30

var font: Font
var lastMax = 2000
var lastMin = 2000
var lastStop = 2000
var lastStart = 2000
var rnd = RandomNumberGenerator.new()

var updateDelay: float = 0.5
var withoutUpdate: float = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	font = Font.new()
	font.add_data(load("res://NotoSansUI_Bold.ttf"))


func _process(delta):
	withoutUpdate += delta
	if withoutUpdate >= updateDelay:
		withoutUpdate = 0
		generateCandle(rnd.randf() >  0.5)
		update()
		
func generateCandle(isPosit: bool):
	rnd.randomize()
	var max = lastMax
	var min = lastMin
	var start = lastStop + (rnd.randf() - 0.5) * 10.
	var stop = lastStop
	if isPosit:
		stop = stop + rnd.randf() * rnd.randf() * 1000
		max = stop + rnd.randf() * rnd.randf() * 1000
		min = start + (rnd.randf() - 1.2) * rnd.randf() * 1000
	else:
		stop = start + (rnd.randf() - 1.2) * rnd.randf() * 1000
		max = start + rnd.randf() * rnd.randf() * 1000
		min = stop + (rnd.randf() - 1.2) * rnd.randf() * 1000
	
	candles.push_back(
		PackedVector2Array([
			Vector2(start, stop),
			Vector2(max, min)
		]))
	if candles.size() > maxCount:
		candles.pop_front()
	lastStart = start
	lastStop = stop
	lastMax = max
	lastMin = min

func _draw():
	#draw_style_box(style,Rect2(Vector2(0., 0.), chart_size))
	draw_rect(Rect2(Vector2(0., 0.), chart_size), Color.black)
	
	draw_coords()
	
	var normalized = []
	var max = 0 if candles.size() < 1 else candles[0][0].x
	var min = 0 if candles.size() < 1 else  candles[0][0].x
	for c in candles:
		for cc in c:
			max = max(cc.x, max(cc.y, max))
			min = min(cc.x, min(cc.y, min))
	
	min = min(0, min)
	
	
	max = abs(max) + abs(min)
	for c in candles:
		var n := PackedVector2Array()
		for cc in c:
			var t = Vector2(1. - (cc.x - min)/max, 1. - (cc.y - min)/max)
			t = t * (chart_size.y * 0.8) + Vector2(chart_size.y * 0.1, chart_size.y * 0.1)
			n.push_back(t)
		normalized.push_back(n)
	
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

func draw_coords():
	var xCount = 20 * (chart_size.x / chart_size.y)
	var xStep = chart_size.x / xCount
	for x in range(1, xCount):
		var curr = x * xStep
		draw_line(Vector2(curr, 0), Vector2(curr, chart_size.y), Color(0.5, 0.5, 0.5, 0.5), 0.2)
	
	var yCount = 20 * (chart_size.y / chart_size.x)
	var yStep = chart_size.y / yCount
	for y in range(1, yCount):
		var curr = y * yStep
		draw_line(Vector2(0, curr), Vector2(chart_size.x, curr), Color(0.5, 0.5, 0.5, 0.5), 0.2)
		draw_string(font, Vector2(10, curr), str(curr), HALIGN_FILL, 50, 14 )
		draw_string(font, Vector2(chart_size.x - 10, curr), str(curr), HALIGN_FILL, 50, 14)
