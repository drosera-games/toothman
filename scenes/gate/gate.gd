class_name Gate extends Node2D

var toothBase: PackedScene = preload("res://scenes/tooth/tooth.tscn")

var moveSpeed: int = 100
var maxViewPortChunks: int = 16
var minTeethViewPortChunks: int = 2
var minScoringAreaViewPortChunks: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var botTooth: Tooth = toothBase.instantiate() as Tooth
	var topTooth: Tooth = toothBase.instantiate() as Tooth

	var viewPortHeight: float = get_viewport().get_visible_rect().size.y
	var viewChunkSize: float = viewPortHeight / maxViewPortChunks
	var baseToothSize: Vector2 = Vector2(64, 64)
	var baseScale: float = viewChunkSize / baseToothSize.y
	print("baseScale: ", baseScale)
	botTooth.apply_scale(Vector2(1, baseScale))
	topTooth.apply_scale(Vector2(1, baseScale))
	$ScoringArea.apply_scale(Vector2(1, baseScale))

	# Get random int for scale of top tooth. Size between minTeethViewportRatio (min viewport chunks that tooth will take up) and maxViewPortChunks - 2x minTeethViewportRatio.
	# The -2x minTeethViewportRatio is to reserve space for the scoring area and for the bottom tooth
	var topToothChunks: int = randi_range(minTeethViewPortChunks, maxViewPortChunks - minTeethViewPortChunks - minScoringAreaViewPortChunks)
	# Get random int for scale of bot tooth. Size between min tooth size and remainder of chunks left - top tooth size - min tooth size (to leave room for score area)
	var botToothChunks: int = randi_range(minTeethViewPortChunks, maxViewPortChunks - topToothChunks - minScoringAreaViewPortChunks)
	# Get chunks left for scale of scoring area
	var scoringAreaChunks: int = maxViewPortChunks - topToothChunks - botToothChunks

	print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	print("topToothChunks: %s" % topToothChunks)
	print("botToothChunks: %s" % botToothChunks)
	print("scoringAreaChunks: %s" % scoringAreaChunks)
	print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

	for chunk: int in topToothChunks - 2:
		if randi() % 2:
			topTooth.addToothChunk()
		else:
			topTooth.addGumChunk()

	for chunk: int in botToothChunks - 2:
		if randi() % 2:
			botTooth.addToothChunk()
		else:
			botTooth.addGumChunk()

	botTooth.flip()

	assert(scoringAreaChunks >= minScoringAreaViewPortChunks)

	$ScoringArea.apply_scale(Vector2(1, scoringAreaChunks))
	$ScoringArea.position.y = topTooth.getHeight() + (scoringAreaChunks * viewChunkSize) / 2

	botTooth.position.y += viewPortHeight - botTooth.getHeight()

	add_child(topTooth)
	add_child(botTooth)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= moveSpeed * delta
