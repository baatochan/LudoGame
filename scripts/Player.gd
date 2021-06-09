extends Node

var id
var pawns = [] # array of pawns (filled during aspawn pawns)
var shouldDiceStartRolling = false
var playerType = ENUMS.PLAYER_TYPE.HUMAN
onready var board = get_node("/root/MainBoardView")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPawns()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): # _delta - _ to suppress compulator warning about param never used
	if board.PLAYER_TURN == id:
		if playerType == ENUMS.PLAYER_TYPE.HUMAN:
			if Input.is_action_just_pressed("ui_select"):
				if (board.GAME_STATE == ENUMS.GAME_STATE.NOT_STARTED):
					shouldDiceStartRolling = true
				elif (board.GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS):
					if (board.TURN_STATE == ENUMS.TURN_STATE.ROLLING):
						shouldDiceStartRolling = true

# add player's pawns to the scene tree
func spawnPawns():
	var playerScript = preload("res://scripts/PlayerPawn.gd")

	for pawnId in range(4):
		# create new pawn sprite
		var pawnNode = Sprite.new()
		pawnNode.name = "Pawn " + str(pawnId)
		pawnNode.script = playerScript
		pawnNode.pawnId = pawnId
		pawnNode.playerId = id
		pawnNode.position = CONSTS.HOME_CORDS[id][pawnId]
		pawnNode.texture = preload("res://sprites/Player.svg")
		pawnNode.modulate = CONSTS.PAWNS_COLORS[id]
		pawnNode.startPosition = CONSTS.START_POSITIONS[id]
		# add this sprite to the array
		pawns.append(pawnNode)
		# add this sprite to the tree (show it)
		add_child(pawns[pawnId])

func isAnyPawnOnBoard():
	var val = true
	if (not pawns[0].isPawnOnBoard()): val = false
	if (not pawns[1].isPawnOnBoard()): val = false
	if (not pawns[2].isPawnOnBoard()): val = false
	if (not pawns[3].isPawnOnBoard()): val = false
	return val

func areAllPawnsFinished():
	return (
		pawns[0].pawnPlace == ENUMS.PAWN_PLACE.FINAL and
		pawns[1].pawnPlace == ENUMS.PAWN_PLACE.FINAL and
		pawns[2].pawnPlace == ENUMS.PAWN_PLACE.FINAL and
		pawns[3].pawnPlace == ENUMS.PAWN_PLACE.FINAL)
