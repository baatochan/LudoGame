extends Sprite

var pawnId
var playerId
var homePositionCords
var currentPosition = null
var startPosition
var distanceFromStart = 0

var label

func _ready():
	spawnLabel()

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

func spawnLabel():
	label = Label.new()
	label.set_text(str(pawnId + 1))
	label.set_align(Label.ALIGN_CENTER)
	label.set_valign(Label.VALIGN_CENTER)
	label.add_font_override("font", preload("res://fonts/default.tres"))
	label.add_color_override("font_color", Color(0,0,0))
	label.margin_left = -20
	label.margin_right = 20
	label.margin_top = -23
	label.margin_bottom = 20
	add_child(label)
