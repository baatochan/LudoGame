extends Node2D

var players = [] # array of players (filled during aspawn players)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPlayers()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): # _delta - _ to suppress compulator warning about param never used
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
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
