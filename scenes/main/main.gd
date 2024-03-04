extends Node2D

var gateScene: PackedScene = preload("res://scenes/gate/gate.tscn")

func spawnGate():
	var newGate: Node2D = gateScene.instantiate()
	newGate.position = $GateSpawn.position
	add_child(newGate)

func stop():
	process_mode = Node.PROCESS_MODE_DISABLED

func _ready():
	spawnGate()

func _on_player_died():
	call_deferred("stop")
	showResults()

func showResults():
	print("done")

func _on_body_level_exited(body):
	print(body)
	if body is Man:
		body.died()
	else:
		print("unknown body left: ", body)


func _on_area_level_exited(area):
	if area is Gate:
		print("removing gate")
		area.queue_free()
	else:
		print("unknown area left: ", area)
