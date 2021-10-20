extends Sprite

var diceSideSprites = [
	preload("res://sprites/dice/side1.png"),
	preload("res://sprites/dice/side2.png"),
	preload("res://sprites/dice/side3.png"),
	preload("res://sprites/dice/side4.png"),
	preload("res://sprites/dice/side5.png"),
	preload("res://sprites/dice/side6.png")]
onready var board = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	var randomSide = randi() % 6 # rand int, range [0, 5]

	set_texture(diceSideSprites[randomSide])


func rollDice(): #async
	var randomSide = 0
	for _i in range(20):
		randomSide = randi() % 6 # rand int, range [0, 5]
		set_texture(diceSideSprites[randomSide])
		yield(get_tree().create_timer(0.05), "timeout")

	board.diceResult = randomSide + 1
	board.isDiceRolling = false
	board.TURN_STATE = ENUMS.TURN_STATE.SELECTING
	board.updateTurnStateLabels()
	printDebug()

func printDebug():
	if CONSTS.IS_DEBUG:
		print("DEBUG: diceRes: " + str(board.diceResult))
