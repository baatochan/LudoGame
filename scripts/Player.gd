extends Node

var playerId
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
	if board.PLAYER_TURN == playerId:
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
		pawnNode.playerId = playerId
		pawnNode.position = CONSTS.HOME_CORDS[playerId][pawnId]
		pawnNode.texture = preload("res://sprites/Player.svg")
		pawnNode.modulate = CONSTS.PAWNS_COLORS[playerId]
		pawnNode.startPosition = CONSTS.START_POSITIONS[playerId]
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

func isAnyPawnInHome():
	var val = false
	if (pawns[0].isPawnInHome()): val = true
	if (pawns[1].isPawnInHome()): val = true
	if (pawns[2].isPawnInHome()): val = true
	if (pawns[3].isPawnInHome()): val = true
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

		if alwaysHit && checkIfHittingIsPossible():
			return
		elif alwaysLeave && isAnyPawnInHome() && board.diceResult == 6 && selectPawnToLeaveHome():
			return
		else:
			match PLAYER_STRATEGY:
				ENUMS.AI_STRATEGY.SOLO:
					selectPawnUsingSoloStrategy()
				ENUMS.AI_STRATEGY.BALANCED:
					selectPawnUsingBalancedStrategy()
				ENUMS.AI_STRATEGY.RANDOM:
					selectPawnUsingRandomStrategy()
				_:
					print("ERROR: Player strategy is not a valplayerId enum value, using fallback strategy")
					# should be removed when correct strategies are implemented and repleced with one of the correct strategies
					selectPawnUsingFallbackStrategy()
		printDebug()

func checkIfHittingIsPossible():
	for pawnId in range(4):
		if pawns[pawnId].isPawnInHome() && board.diceResult == 6:
			if board.checkIfPositionIsOccupied(pawns[pawnId].startPosition, playerId):
				choosenPawn = pawnId
				return true
		elif pawns[pawnId].isPawnOnBoard():
			if board.checkIfPositionIsOccupied(pawns[pawnId].currentPosition + board.diceResult, playerId):
				choosenPawn = pawnId
				return true
	return false

func selectPawnToLeaveHome():
	for pawnId in range(4):
		if pawns[pawnId].isPawnInHome():
			choosenPawn = pawnId
			return true
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

func selectPawnUsingSoloStrategy():
	printDebug()
	if (isAnyPawnOnBoard()):
		selectTheFurthestPawn()
	else:
		if board.diceResult == 6:
			var isSelected = selectPawnToLeaveHome()
			if (not isSelected):
				fallbackToFallbackStrategy("solo (3)")
		else:
			fallbackToFallbackStrategy("solo (1)")

func selectTheFurthestPawn():
	var status = getPawnStatus()
	var furthestDistance = -11
	var furthestPawn = null
	for pawnId in range(4):
		if pawns[pawnId].isPawnOnBoard():
			if furthestDistance < status[pawnId].y:
				furthestDistance = status[pawnId].y
				furthestPawn = pawnId
	if furthestPawn != null:
		choosenPawn = furthestPawn
	else:
		fallbackToFallbackStrategy("solo (2)")

func getPawnStatus():
	var status = []
	for pawnId in range(4):
		status.append(Vector2(pawns[pawnId].pawnPlace, pawns[pawnId].distanceFromStart))
	return status

func fallbackToFallbackStrategy(strategyName):
	print("ERROR: "  + str(strategyName) + " strategy had a problem and stopped working, using fallback strategy")
	printDebug(true)
	selectPawnUsingFallbackStrategy()

func selectPawnUsingBalancedStrategy():
	printDebug()
	if board.diceResult == 6:
		selectTheNearestPawn()
	else:
		selectTheNearestPawnFromBoard()

func selectTheNearestPawn():
	var status = getPawnStatus()
	var nearestDistance = 40
	var nearestPawn = null
	for pawnId in range(4):
		if nearestDistance > status[pawnId].y:
			nearestDistance = status[pawnId].y
			nearestPawn = pawnId
	if nearestPawn != null:
		choosenPawn = nearestPawn
	else:
		fallbackToFallbackStrategy("balanced (1)")

func selectTheNearestPawnFromBoard():
	var status = getPawnStatus()
	var nearestDistance = 40
	var nearestPawn = -1
	for pawnId in range(4):
		if pawns[pawnId].isPawnOnBoard():
			if nearestDistance > status[pawnId].y:
				nearestDistance = status[pawnId].y
				nearestPawn = pawnId
	if nearestPawn != -1:
		choosenPawn = nearestPawn
	else:
		fallbackToFallbackStrategy("balanced (1)")

func selectPawnUsingRandomStrategy():
	printDebug()
	if board.diceResult == 6 && isAnyPawnOnBoard() && isAnyPawnInHome():
		var leaveChance = randi() % 2
		if leaveChance == 0:
			selectRandomPawnFromHome()
		else:
			selectRandomPawnFromBoard()
	elif board.diceResult == 6 && isAnyPawnInHome():
		selectRandomPawnFromHome()
	elif isAnyPawnOnBoard():
		selectRandomPawnFromBoard()
	else:
		fallbackToFallbackStrategy("random (1)")

func selectRandomPawnFromHome():
	var choosen = randi() % 4 # rand int, range [0, 3]
	while (not pawns[choosen].isPawnInHome()):
		choosen = randi() % 4
	choosenPawn = choosen

func selectRandomPawnFromBoard():
	var choosen = randi() % 4 # rand int, range [0, 3]
	while (not pawns[choosen].isPawnOnBoard()):
		choosen = randi() % 4
	choosenPawn = choosen

func printDebug(printAnyway = false):
	if CONSTS.IS_DEBUG or printAnyway:
		var status = getPawnStatus()
		print("DEBUG: playerId: " + str(playerId) + "; pawnPositions: 1 - " + str(status[0]) + ", 2 - " + str(status[1]) + ", 3 - " + str(status[2]) + ", 4 - " + str(status[3]))
		print("DEBUG: selectedPawn: " + str(choosenPawn))
