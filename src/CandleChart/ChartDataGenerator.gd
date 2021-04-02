extends Node

@export_node_path(Node2D) var chartPath: NodePath
@export_range(0.1, 10) var updateDelay: float
@export_range(0, 1) var growthProbability: float
 
var withoutUpdate: float = 0
var chart
var lastMax = 2000
var lastMin = 2000
var lastStop = 2000
var lastStart = 2000
var rnd = RandomNumberGenerator.new()

func _ready():
	chart = get_node(chartPath)
	if !chart.has_method("add_candle"):
		chart = null
		
	if !updateDelay:
		updateDelay  = 0.1 
	
	if !growthProbability:
		growthProbability  = 0.5  

func _process(delta):
	if !chart:
		return
	withoutUpdate += delta
	if withoutUpdate >= updateDelay:
		withoutUpdate = 0
		generateCandle(rnd.randf() <=  growthProbability)
		chart.update()
		
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
	
	chart.add_candle(
		PackedVector2Array([
			Vector2(start, stop),
			Vector2(max, min)
		]))
	lastStart = start
	lastStop = stop
	lastMax = max
	lastMin = min	
