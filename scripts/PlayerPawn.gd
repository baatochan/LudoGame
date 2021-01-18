extends Sprite

var POSITION_CORDS = preload("res://consts/CORDS.gd")

var pawnId
var playerId
var homePositionCords
var currentPosition = null
var startPosition
var distanceFromStart = 0

func _ready():
	pass

func move(var numberOfFieldsToMove):
	if (currentPosition == null):
		currentPosition = startPosition
		position = POSITION_CORDS.value[startPosition]
	else:
		if (distanceFromStart >= 39):
			return false
			pass
		if (currentPosition + numberOfFieldsToMove >= 40):
			currentPosition += numberOfFieldsToMove - 40
			distanceFromStart += numberOfFieldsToMove
			position = POSITION_CORDS.value[currentPosition]
		else:
			currentPosition += numberOfFieldsToMove
			distanceFromStart += numberOfFieldsToMove
			position = POSITION_CORDS.value[currentPosition]
	return true
	pass

func sendToHome():
	currentPosition = null
	distanceFromStart = 0
	position = homePositionCords
	pass
