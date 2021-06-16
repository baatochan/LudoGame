extends Node

var id
var pawns = [] # array of pawns (filled during aspawn pawns)
var shouldDiceStartRolling = false
var choosenPawn = null
var PLAYER_STATE = ENUMS.PLAYER_STATE.NEW_TURN # not really needed for human player, at least with this design

var PLAYER_TYPE
var PLAYER_STRATEGY
var alwaysHit
var alwaysLeave

onready var board = get_node("/root/MainBoardView")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPawns()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): # _delta - _ to suppress compulator warning about param never used
	if board.PLAYER_TURN == id:
		if PLAYER_TYPE == ENUMS.PLAYER_TYPE.AI:
			if (board.GAME_STATE == ENUMS.GAME_STATE.NOT_STARTED):
				rollDice(rand_range(CONSTS.MIN_START_GAME_WAIT_TIMER, CONSTS.MAX_START_GAME_WAIT_TIMER))
			elif (board.GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS):
				if (board.TURN_STATE == ENUMS.TURN_STATE.ROLLING):
					rollDice(rand_range(CONSTS.MIN_ROLL_WAIT_TIMER, CONSTS.MAX_ROLL_WAIT_TIMER))
				elif (board.TURN_STATE == ENUMS.TURN_STATE.SELECTING):
					selectPawnByAI(rand_range(CONSTS.MIN_MOVE_WAIT_TIMER, CONSTS.MAX_MOVE_WAIT_TIMER))
		else:
			if Input.is_action_just_pressed("ui_select"):
				if (board.GAME_STATE == ENUMS.GAME_STATE.NOT_STARTED):
					rollDice()
				elif (board.GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS):
					if (board.TURN_STATE == ENUMS.TURN_STATE.ROLLING):
						rollDice()
			elif (board.GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS and board.TURN_STATE == ENUMS.TURN_STATE.SELECTING):
				if Input.is_action_just_pressed("1"):
					selectPawn(0)
				elif Input.is_action_just_pressed("2"):
					selectPawn(1)
				elif Input.is_action_just_pressed("3"):
					selectPawn(2)
				elif Input.is_action_just_pressed("4"):
					selectPawn(3)

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
	var val = false
	if (pawns[0].isPawnOnBoard()): val = true
	if (pawns[1].isPawnOnBoard()): val = true
	if (pawns[2].isPawnOnBoard()): val = true
	if (pawns[3].isPawnOnBoard()): val = true
	return val

func areAllPawnsFinished():
	return (
		pawns[0].pawnPlace == ENUMS.PAWN_PLACE.FINAL and
		pawns[1].pawnPlace == ENUMS.PAWN_PLACE.FINAL and
		pawns[2].pawnPlace == ENUMS.PAWN_PLACE.FINAL and
		pawns[3].pawnPlace == ENUMS.PAWN_PLACE.FINAL)

func rollDice(timer = 0):
	if (PLAYER_STATE == ENUMS.PLAYER_STATE.NEW_TURN):
		PLAYER_STATE = ENUMS.PLAYER_STATE.ROLLED
		if (timer > 0):
			yield(get_tree().create_timer(timer), "timeout")
		shouldDiceStartRolling = true

func selectPawn(pawn):
	if (PLAYER_STATE == ENUMS.PLAYER_STATE.ROLLED):
		PLAYER_STATE = ENUMS.PLAYER_STATE.SELECTED
		choosenPawn = pawn

func selectPawnByAI(timer):
	if (PLAYER_STATE == ENUMS.PLAYER_STATE.ROLLED):
		PLAYER_STATE = ENUMS.PLAYER_STATE.SELECTED
		if timer > 0:
			yield(get_tree().create_timer(timer), "timeout")

		if (alwaysHit):
			if checkIfHittingIsPossible():
				return
		elif (alwaysLeave):
			if board.diceResult == 6:
				var isSelected = selectPawnToLeaveHome()
				if isSelected:
					return
		else:
			match PLAYER_STRATEGY:
				# to be implemented
				_:
					print("Player strategy is not a valid enum value, using fallback strategy")
					# should be removed when correct strategies are implemented and repleced with one of the correct strategies
					selectPawnUsingFallbackStrategy()

func checkIfHittingIsPossible():
	# to be implemented
	return false

func selectPawnToLeaveHome():
	# to be implemented
	return false

# should be removed when correct strategies are implemented
func selectPawnUsingFallbackStrategy():
	if (isAnyPawnOnBoard()):
		var choosen = randi() % 4 # rand int, range [0, 3]
		while (not pawns[choosen].isPawnOnBoard()):
			choosen = randi() % 4
		choosenPawn = choosen
	else:
		var choosen = randi() % 4 # rand int, range [0, 3]
		while (not pawns[choosen].isPawnInHome()):
			choosen = randi() % 4
		choosenPawn = choosen
