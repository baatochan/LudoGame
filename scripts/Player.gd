extends Node

var id
var pawns = [] # array of pawns (filled during aspawn pawns)
var shouldDiceStartRolling = false
var choosenPawn = null
var playerType = ENUMS.PLAYER_TYPE.HUMAN
onready var board = get_node("/root/MainBoardView")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # set seed for rand generator

	spawnPawns()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): # _delta - _ to suppress compulator warning about param never used
	if board.PLAYER_TURN == id:
		if playerType == ENUMS.PLAYER_TYPE.AI:
			# LEAKY CODE, REMOVE IT
			# leaky code for AI player, game can be played with this code but it's completly not how it should be done.
			if (board.GAME_STATE == ENUMS.GAME_STATE.NOT_STARTED):
				yield(get_tree().create_timer(1.0), "timeout")
				shouldDiceStartRolling = true
			elif (board.GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS):
				if (board.TURN_STATE == ENUMS.TURN_STATE.ROLLING):
					yield(get_tree().create_timer(1.0), "timeout")
					shouldDiceStartRolling = true
				elif (board.TURN_STATE == ENUMS.TURN_STATE.SELECTING):
					yield(get_tree().create_timer(1.0), "timeout")
					choosenPawn = randi() % 4 # rand int, range [0, 3]
			# LEAKY CODE, REMOVE IT
		else:
			if Input.is_action_just_pressed("ui_select"):
				if (board.GAME_STATE == ENUMS.GAME_STATE.NOT_STARTED):
					shouldDiceStartRolling = true
				elif (board.GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS):
					if (board.TURN_STATE == ENUMS.TURN_STATE.ROLLING):
						shouldDiceStartRolling = true
			elif (board.GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS and board.TURN_STATE == ENUMS.TURN_STATE.SELECTING):
				if Input.is_action_just_pressed("1"):
					choosenPawn = 0;
				elif Input.is_action_just_pressed("2"):
					choosenPawn = 1;
				elif Input.is_action_just_pressed("3"):
					choosenPawn = 2;
				elif Input.is_action_just_pressed("4"):
					choosenPawn = 3;

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
