extends Sprite

var pawnId
var playerId
var currentPosition = null
var startPosition
var distanceFromStart = -10
var pawnPlace = ENUMS.PAWN_PLACE.HOME

var label

func _ready():
	spawnLabel()

func move(var numberOfFieldsToMove):
	if (pawnPlace == ENUMS.PAWN_PLACE.HOME):
		if (numberOfFieldsToMove == 6):
			currentPosition = startPosition
			position = CONSTS.FIELDS_CORDS[startPosition]
			pawnPlace = ENUMS.PAWN_PLACE.BOARD
			distanceFromStart = 0
		else:
			return ENUMS.MOVE_RESULT.NOT_SUCCESSFUL
	elif (pawnPlace == ENUMS.PAWN_PLACE.FINAL):
		return ENUMS.MOVE_RESULT.NOT_SUCCESSFUL
	else:
		if (distanceFromStart + numberOfFieldsToMove > 39):
			currentPosition = null
			distanceFromStart = 40
			pawnPlace = ENUMS.PAWN_PLACE.FINAL
			position = CONSTS.FINAL_CORDS[playerId][pawnId]
			return ENUMS.MOVE_RESULT.FINAL
			pass
		if (currentPosition + numberOfFieldsToMove >= 40):
			currentPosition += numberOfFieldsToMove - 40
			distanceFromStart += numberOfFieldsToMove
			position = CONSTS.FIELDS_CORDS[currentPosition]
		elif (currentPosition + numberOfFieldsToMove < 0):
			currentPosition += numberOfFieldsToMove + 40
			distanceFromStart += numberOfFieldsToMove
			position = CONSTS.FIELDS_CORDS[currentPosition]
		else:
			currentPosition += numberOfFieldsToMove
			distanceFromStart += numberOfFieldsToMove
			position = CONSTS.FIELDS_CORDS[currentPosition]
	return ENUMS.MOVE_RESULT.SUCCESSFUL

func sendToHome():
	currentPosition = null
	distanceFromStart = -10
	pawnPlace = ENUMS.PAWN_PLACE.HOME
	position = CONSTS.HOME_CORDS[playerId][pawnId]

func isPawnOnBoard():
	return (pawnPlace == ENUMS.PAWN_PLACE.BOARD)

func isPawnInHome():
	return (pawnPlace == ENUMS.PAWN_PLACE.HOME)

func spawnLabel():
	label = Label.new()
	label.set_text(str(pawnId + 1))
	label.set_align(Label.ALIGN_CENTER)
	label.set_valign(Label.VALIGN_CENTER)
	label.add_font_override("font", preload("res://fonts/default32.tres"))
	label.add_color_override("font_color", Color(0,0,0))
	label.margin_left = -20
	label.margin_right = 20
	label.margin_top = -23
	label.margin_bottom = 20
	add_child(label)
