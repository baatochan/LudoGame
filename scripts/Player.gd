extends Node

# scripts with consts
var PLAYER_HOME_CORDS = preload("res://consts/PLAYER_HOME_CORDS.gd")
var PLAYER_COLORS = preload("res://consts/PLAYER_COLORS.gd")
var PLAYER_START_POSITIONS = preload("res://consts/PLAYER_START_POSITIONS.gd")

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
		pawnNode.position = PLAYER_HOME_CORDS.value[id][pawnId]
		pawnNode.homePositionCords = PLAYER_HOME_CORDS.value[id][pawnId]
		pawnNode.texture = preload("res://sprites/Player.svg")
		pawnNode.modulate = PLAYER_COLORS.pawnsColors[id]
		pawnNode.startPosition = PLAYER_START_POSITIONS.value[id]
		# add this sprite to the array
		pawns.append(pawnNode)
		# add this sprite to the tree (show it)
		add_child(pawns[pawnId])
	pass

func areAllPawnsHome():
	var val = true
	if (not pawns[0].isPawnHome()): val = false
	if (not pawns[1].isPawnHome()): val = false
	if (not pawns[2].isPawnHome()): val = false
	if (not pawns[3].isPawnHome()): val = false
	return val
