extends Sprite

var diceResult = 1
var isRolling = false;

var diceSideSprites = [
	preload("res://sprites/dice/side1.png"),
	preload("res://sprites/dice/side2.png"),
	preload("res://sprites/dice/side3.png"),
	preload("res://sprites/dice/side4.png"),
	preload("res://sprites/dice/side5.png"),
	preload("res://sprites/dice/side6.png")]


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # set seed for rand generator

	var randomSide = randi() % 6 # rand int, range [0, 5]

	set_texture(diceSideSprites[randomSide])
	diceResult = randomSide + 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		if not isRolling:
			isRolling = true
			roll_dice()
	pass


func roll_dice():
	var randomSide = 0
	for _i in range(20):
		randomSide = randi() % 6 # rand int, range [0, 5]
		set_texture(diceSideSprites[randomSide])
		yield(get_tree().create_timer(0.05), "timeout")

	diceResult = randomSide + 1
	isRolling = false
	pass
