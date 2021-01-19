extends Node2D

var players = [] # array of players (filled during aspawn players)
var playerPositions = [] # array with every 40 positions and values Vector2(playerId, pawnId) or NULL (if position is not occupied)

var GAME_STATE = ENUMS.GAME_STATE.NOT_STARTED
var TURN_STATE = ENUMS.TURN_STATE.ROLLING
var PLAYER_TURN = 0
var isDiceRolling = false
var diceResult

# Called when the node enters the scene tree for the first time.
func _ready():
	playerPositions.resize(40) # fill array of player positions with nulls
	spawnPlayers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): # _delta - _ to suppress compulator warning about param never used
	if (TURN_STATE == ENUMS.TURN_STATE.SELECTING and diceResult != 6 and players[PLAYER_TURN].isAnyPawnOnBoard()):
		nextPlayer()
	elif (players[PLAYER_TURN].areAllPawnsFinished()):
		nextPlayer()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_select"):
		if (GAME_STATE == ENUMS.GAME_STATE.NOT_STARTED):
			GAME_STATE = ENUMS.GAME_STATE.IN_PROGRESS
			rollDice()
		elif (GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS):
			if (TURN_STATE == ENUMS.TURN_STATE.ROLLING):
				if (not isDiceRolling):
					rollDice()
	elif Input.is_action_just_pressed("1"):
		if (GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS and TURN_STATE == ENUMS.TURN_STATE.SELECTING):
			var isSuccessfulMovement = movePawn(0)
			if isSuccessfulMovement: nextPlayer()
	elif Input.is_action_just_pressed("2"):
		if (GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS and TURN_STATE == ENUMS.TURN_STATE.SELECTING):
			var isSuccessfulMovement = movePawn(1)
			if isSuccessfulMovement: nextPlayer()
	elif Input.is_action_just_pressed("3"):
		if (GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS and TURN_STATE == ENUMS.TURN_STATE.SELECTING):
			var isSuccessfulMovement = movePawn(2)
			if isSuccessfulMovement: nextPlayer()
	elif Input.is_action_just_pressed("4"):
		if (GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS and TURN_STATE == ENUMS.TURN_STATE.SELECTING):
			var isSuccessfulMovement = movePawn(3)
			if isSuccessfulMovement: nextPlayer()

# add player nodes to the scene tree
func spawnPlayers():
	var playerScript = preload("res://scripts/Player.gd")

	for playerId in range(4):
		# create new node for player
		var playerNode = Node.new()
		playerNode.name = "Player " + str(playerId)
		playerNode.script = playerScript
		playerNode.id = playerId
		# add this node to the array
		players.append(playerNode)
		# add this node to the tree (show it)
		add_child(players[playerId])

func rollDice():
	isDiceRolling = true
	$Dice.roll_dice()

func nextPlayer():
	TURN_STATE = ENUMS.TURN_STATE.ROLLING
	PLAYER_TURN += 1
	if (PLAYER_TURN > 3):
		PLAYER_TURN = 0

func movePawn(var pawn, var numberToMove = diceResult):
	var selectedPawn = players[PLAYER_TURN].pawns[pawn]
	var oldPosition = selectedPawn.currentPosition
	var isMoved = selectedPawn.move(numberToMove)
	if (isMoved == ENUMS.MOVE_RESULT.SUCCESSFUL):
		if (oldPosition != null):
			playerPositions[oldPosition] = null
		if (playerPositions[selectedPawn.currentPosition] != null):
			var oldPlayerData = playerPositions[selectedPawn.currentPosition]
			if (oldPlayerData.x == PLAYER_TURN):
				movePawn(oldPlayerData.y, -1)
			else:
				players[oldPlayerData.x].pawns[oldPlayerData.y].sendToHome()
		playerPositions[selectedPawn.currentPosition] = Vector2(PLAYER_TURN, pawn)
		return true
	elif (isMoved == ENUMS.MOVE_RESULT.FINAL):
		if (oldPosition != null):
			playerPositions[oldPosition] = null
		return true
	else:
		return false
