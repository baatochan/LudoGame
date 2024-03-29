extends Node2D

var players = [] # array of players (filled during spawn players)
var playerPositions = [] # array with every 40 positions and values Vector2(playerId, pawnId) or NULL (if position is not occupied)

var GAME_STATE = ENUMS.GAME_STATE.LOADING
var TURN_STATE = ENUMS.TURN_STATE.ROLLING
var PLAYER_TURN = 0
var isDiceRolling = false
var diceResult

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # set seed for rand generator
	playerPositions.resize(40) # fill array of player positions with nulls
	spawnPlayers()
	updateTurnStateLabels()
	yield(get_tree().create_timer(1.0), "timeout") # without that starting the scene with spacebar starts the game # todo: find a proper solution to ignore that input
	GAME_STATE = ENUMS.GAME_STATE.NOT_STARTED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): # _delta - _ to suppress compulator warning about param never used
	if (TURN_STATE == ENUMS.TURN_STATE.SELECTING and diceResult != 6 and (not players[PLAYER_TURN].isAnyPawnOnBoard())):
		nextPlayer()

	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().change_scene("res://scenes/PlayerSelection.tscn") != OK:
			print ("An unexpected error occured when trying to switch to the PlayerSelection scene")

	if players[PLAYER_TURN].shouldDiceStartRolling == true:
		if (GAME_STATE == ENUMS.GAME_STATE.NOT_STARTED):
			updatePlayerLabel()
			GAME_STATE = ENUMS.GAME_STATE.IN_PROGRESS
			rollDice()
		elif (GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS):
			if (TURN_STATE == ENUMS.TURN_STATE.ROLLING):
				if (not isDiceRolling):
					rollDice()

	if (GAME_STATE == ENUMS.GAME_STATE.IN_PROGRESS and TURN_STATE == ENUMS.TURN_STATE.SELECTING):
		if players[PLAYER_TURN].choosenPawn != null:
			var isSuccessfulMovement = movePawn(players[PLAYER_TURN].choosenPawn)
			var isWinning = checkIfWinning()
			players[PLAYER_TURN].choosenPawn = null
			if (isSuccessfulMovement and not isWinning):
				if (diceResult == 6):
					anotherRoll()
				else:
					nextPlayer()

# add player nodes to the scene tree
func spawnPlayers():
	var playerScript = preload("res://scripts/Player.gd")

	for playerId in range(4):
		# create new node for player
		var playerNode = Node.new()
		playerNode.name = "Player " + str(playerId)
		playerNode.script = playerScript
		playerNode.playerId = playerId
		playerNode.PLAYER_TYPE = Settings.PLAYERS_SETTINGS[playerId][0]
		playerNode.PLAYER_STRATEGY = Settings.PLAYERS_SETTINGS[playerId][1]
		playerNode.alwaysHit = Settings.PLAYERS_SETTINGS[playerId][2]
		playerNode.alwaysLeave = Settings.PLAYERS_SETTINGS[playerId][3]
		# add this node to the array
		players.append(playerNode)
		# add this node to the tree (show it)
		add_child(players[playerId])

func rollDice():
	players[PLAYER_TURN].shouldDiceStartRolling = false
	isDiceRolling = true
	$Dice.rollDice()

func anotherRoll():
	players[PLAYER_TURN].PLAYER_STATE = ENUMS.PLAYER_STATE.NEW_TURN
	TURN_STATE = ENUMS.TURN_STATE.ROLLING
	updateTurnStateLabels()
	printDebug()

func nextPlayer():
	players[PLAYER_TURN].PLAYER_STATE = ENUMS.PLAYER_STATE.NEW_TURN
	TURN_STATE = ENUMS.TURN_STATE.ROLLING
	PLAYER_TURN += 1
	if (PLAYER_TURN > 3):
		PLAYER_TURN = 0
	updatePlayerLabel()
	updateTurnStateLabels()
	printDebug()

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

func checkIfWinning(var player = PLAYER_TURN):
	if (players[player].areAllPawnsFinished()):
		GAME_STATE = ENUMS.GAME_STATE.FINISHED
		TURN_STATE = null
		updateTurnStateLabels()
		setWinningPlayer()
		return true
	else:
		return false

func checkIfPositionIsOccupied(position, ally):
	if position < 0:
		position += 40
	if position > 39:
		position -= 40

	if playerPositions[position] != null:
		if playerPositions[position].x != ally:
			return true
	else:
		return false

func updatePlayerLabel(var player = PLAYER_TURN):
	$MainLabelNode/Label.text = "Player " + str(player + 1)
	$MainLabelNode/Label.add_color_override("font_color", CONSTS.FIELDS_COLORS[player])

func updateTurnStateLabels(var state = TURN_STATE):
	if (state == ENUMS.TURN_STATE.ROLLING):
		$TurnStateLabelNode/Label.text = "Roll a dice"
		$HintLabelNode/Label.text = "Use a space key"
	elif (state == ENUMS.TURN_STATE.SELECTING):
		$TurnStateLabelNode/Label.text = "Select a pawn"
		$HintLabelNode/Label.text = "Use keys: 1, 2, 3 or 4"
	else:
		$TurnStateLabelNode/Label.text = ""
		$HintLabelNode/Label.text = ""

func setWinningPlayer(var player = PLAYER_TURN):
	$MainLabelNode/Label.text = "Player " + str(player + 1) + " won!"
	$MainLabelNode/Label.add_color_override("font_color", CONSTS.FIELDS_COLORS[player])

func printDebug():
	if CONSTS.IS_DEBUG:
		print("\n\n")
