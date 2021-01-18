extends Sprite

var pawnId
var playerId
var homePositionCords
var currentPosition = null
var startPosition
var distanceFromStart = 0

func move(var numberOfFieldsToMove):
	if (currentPosition == null):
		if (numberOfFieldsToMove == 6):
			currentPosition = startPosition
			position = CONSTS.FIELDS_CORDS[startPosition]
		else:
			return false
	else:
		if (distanceFromStart >= 39):
			return false
			pass
		if (currentPosition + numberOfFieldsToMove >= 40):
			currentPosition += numberOfFieldsToMove - 40
			distanceFromStart += numberOfFieldsToMove
			position = CONSTS.FIELDS_CORDS[currentPosition]
		else:
			currentPosition += numberOfFieldsToMove
			distanceFromStart += numberOfFieldsToMove
			position = CONSTS.FIELDS_CORDS[currentPosition]
	return true

func sendToHome():
	currentPosition = null
	distanceFromStart = 0
	position = homePositionCords

func isPawnHome():
	return (currentPosition == null)
