extends Node2D

var players = [] # array of players (filled during aspawn players)
var playerPositions = [] # array with every 40 positions and values Vector2(playerId, pawnId) or NULL (if position is not occupied)

# Called when the node enters the scene tree for the first time.
func _ready():
	playerPositions.resize(40) # fill array of player positions with nulls
	spawnPlayers()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): # _delta - _ to suppress compulator warning about param never used
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_right"):
		var oldPosition = players[2].pawns[0].currentPosition
		var isMoved = players[2].pawns[0].move(1)
		if (isMoved):
			if (oldPosition != null):
				playerPositions[oldPosition] = null
			if (playerPositions[players[2].pawns[0].currentPosition] != null):
				var oldPlayerData = playerPositions[players[2].pawns[0].currentPosition]
				players[oldPlayerData.x].pawns[oldPlayerData.y].sendToHome()
			playerPositions[players[2].pawns[0].currentPosition] = Vector2(2, 0)
			pass
	elif Input.is_action_just_pressed("ui_left"):
		var oldPosition = players[0].pawns[0].currentPosition
		var isMoved = players[0].pawns[0].move(1)
		if (isMoved):
			if (oldPosition != null):
				playerPositions[oldPosition] = null
			if (playerPositions[players[0].pawns[0].currentPosition] != null):
				var oldPlayerData = playerPositions[players[0].pawns[0].currentPosition]
				players[oldPlayerData.x].pawns[oldPlayerData.y].sendToHome()
			playerPositions[players[0].pawns[0].currentPosition] = Vector2(0, 0)
			pass
	pass

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
	pass
