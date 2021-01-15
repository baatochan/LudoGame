extends Node

# scripts with consts
var PLAYER_HOME_POSITIONS = preload("res://consts/PLAYER_HOME_POSITIONS.gd")
var PLAYER_COLORS = preload("res://consts/PLAYER_COLORS.gd")

var id
var pawns = [] # array of pawns (filled during aspawn pawns)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPawns()
	pass

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
		pawnNode.position = PLAYER_HOME_POSITIONS.value[id][pawnId]
		pawnNode.homePosition = PLAYER_HOME_POSITIONS.value[id][pawnId]
		pawnNode.texture = preload("res://sprites/Player.svg")
		pawnNode.modulate = PLAYER_COLORS.pawnsColors[id]
		# add this sprite to the array
		pawns.append(pawnNode)
		# add this sprite to the tree (show it)
		add_child(pawns[pawnId])
	pass
