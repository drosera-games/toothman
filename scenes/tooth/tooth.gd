class_name Tooth extends StaticBody2D

var gumChunkTexture = preload("res://scenes/tooth/gumchunk.png")
var toothChunkTexture = preload("res://scenes/tooth/toothchunk.png")

enum CHUNK_TYPE {
	TOOTH,
	GUM
}

func addChunk(type: CHUNK_TYPE):
	var texture: Resource
	var containerNode: Node2D
	var endNode: Node2D
	var newChunk: Sprite2D = Sprite2D.new()
	newChunk.flip_h = true
	newChunk.flip_v = true
	newChunk.position.x = 0

	if type == CHUNK_TYPE.TOOTH:
		texture = toothChunkTexture
		containerNode = $Pieces/Tooth
		endNode = $Pieces/Tooth/ToothTop
	else:
		texture = gumChunkTexture
		containerNode = $Pieces/Gums
		endNode = $Pieces/Gums/GumTop
		$Pieces/Tooth.position.y += gumChunkTexture.get_height()

	var textureHeight: float = texture.get_height()
	newChunk.texture = texture
	newChunk.position.y = endNode.position.y -textureHeight / 2
	endNode.position.y += textureHeight
	containerNode.add_child(newChunk)
	$CollisionShape2D.shape.size += Vector2(0, textureHeight)
	$CollisionShape2D.position.y += textureHeight / 2

func addToothChunk():
	addChunk(CHUNK_TYPE.TOOTH)

func addGumChunk():
	addChunk(CHUNK_TYPE.GUM)

func getHeight() -> float: return ($Pieces/Gums.get_child_count() * gumChunkTexture.get_height() + $Pieces/Tooth.get_child_count() * toothChunkTexture.get_height()) * scale.y

func flip():
	rotation_degrees = 180
	position.y += getHeight()
	position.x += toothChunkTexture.get_width()
