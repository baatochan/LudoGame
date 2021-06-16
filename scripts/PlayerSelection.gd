extends Node2D

var playerSettings = [
	[ENUMS.PLAYER_TYPE.HUMAN, ENUMS.AI_STRATEGY.SOLO, false, false],
	[ENUMS.PLAYER_TYPE.HUMAN, ENUMS.AI_STRATEGY.SOLO, false, false],
	[ENUMS.PLAYER_TYPE.HUMAN, ENUMS.AI_STRATEGY.SOLO, false, false],
	[ENUMS.PLAYER_TYPE.HUMAN, ENUMS.AI_STRATEGY.SOLO, false, false]]

# ================================================== #
# ================================================== #

var standardButton = Color.gray
var highlightedButton = Color.greenyellow

var optionalButtonRed = Color.webgray
var optionalButtonBlue = Color.webgray
var optionalButtonGreen = Color.webgray
var optionalButtonYellow = Color.webgray

func object_features_init():
	$HumanMarkRed.visible = true
	$AIMarkRed.visible = false
	$HumanMarkBlue.visible = true
	$AIMarkBlue.visible = false
	$HumanMarkGreen.visible = true
	$AIMarkGreen.visible = false
	$HumanMarkYellow.visible = true
	$AIMarkYellow.visible = false

	$StartGameRect/Text.text = "START GAME"
	$QuitRect/Text.text = "QUIT"

	$ControlRed/Text.text = "CHOOSE TYPE"
	$StrategyRed/Text.text = "SOLO"
	$OptionOneRed/Text.text = "ALWAYS HIT: OFF"
	$OptionTwoRed/Text.text = "ALWAYS LEAVE: OFF"

	$ControlBlue/Text.text = "CHOOSE TYPE"
	$StrategyBlue/Text.text = "SOLO"
	$OptionOneBlue/Text.text = "ALWAYS HIT: OFF"
	$OptionTwoBlue/Text.text = "ALWAYS LEAVE: OFF"

	$ControlGreen/Text.text = "CHOOSE TYPE"
	$StrategyGreen/Text.text = "SOLO"
	$OptionOneGreen/Text.text = "ALWAYS HIT: OFF"
	$OptionTwoGreen/Text.text = "ALWAYS LEAVE: OFF"

	$ControlYellow/Text.text = "CHOOSE TYPE"
	$StrategyYellow/Text.text = "SOLO"
	$OptionOneYellow/Text.text = "ALWAYS HIT: OFF"
	$OptionTwoYellow/Text.text = "ALWAYS LEAVE: OFF"

# ================================================== #
# ================================================== #

# UP / DOWN
var selected_menu = 0
# LEFT / RIGHT
var selected_player = 0

func change_menu_color():
	$StartGameRect.color = standardButton

	$ControlRed.color = standardButton
	$StrategyRed.color = optionalButtonRed
	$OptionOneRed.color = optionalButtonRed
	$OptionTwoRed.color = optionalButtonRed

	$ControlBlue.color = standardButton
	$StrategyBlue.color = optionalButtonBlue
	$OptionOneBlue.color = optionalButtonBlue
	$OptionTwoBlue.color = optionalButtonBlue

	$ControlGreen.color = standardButton
	$StrategyGreen.color = optionalButtonGreen
	$OptionOneGreen.color = optionalButtonGreen
	$OptionTwoGreen.color = optionalButtonGreen

	$ControlYellow.color = standardButton
	$StrategyYellow.color = optionalButtonYellow
	$OptionOneYellow.color = optionalButtonYellow
	$OptionTwoYellow.color = optionalButtonYellow

	$QuitRect.color = standardButton

	match selected_menu:
		0:
			$StartGameRect.color = highlightedButton
		1:
			match selected_player:
				0:
					$ControlRed.color = highlightedButton
				1:
					$ControlBlue.color = highlightedButton
				2:
					$ControlGreen.color = highlightedButton
				3:
					$ControlYellow.color = highlightedButton
		2:
			match selected_player:
				0:
					$StrategyRed.color = highlightedButton
				1:
					$StrategyBlue.color = highlightedButton
				2:
					$StrategyGreen.color = highlightedButton
				3:
					$StrategyYellow.color = highlightedButton
		3:
			match selected_player:
				0:
					$OptionOneRed.color = highlightedButton
				1:
					$OptionOneBlue.color = highlightedButton
				2:
					$OptionOneGreen.color = highlightedButton
				3:
					$OptionOneYellow.color = highlightedButton
		4:
			match selected_player:
				0:
					$OptionTwoRed.color = highlightedButton
				1:
					$OptionTwoBlue.color = highlightedButton
				2:
					$OptionTwoGreen.color = highlightedButton
				3:
					$OptionTwoYellow.color = highlightedButton
		5:
			$QuitRect.color = highlightedButton

# ================================================== #
# ================================================== #

func _ready():
	object_features_init()
	change_menu_color()

func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		if selected_menu < 5:
			selected_menu = selected_menu + 1
		else:
			selected_menu = 0
		change_menu_color()
	elif Input.is_action_just_pressed("ui_up"):
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 5
		change_menu_color()
	elif Input.is_action_just_pressed("ui_right"):
		if selected_player < 3:
			selected_player = selected_player + 1
		else:
			selected_player = 0
		change_menu_color()
	elif Input.is_action_just_pressed("ui_left"):
		if selected_player > 0:
			selected_player = selected_player - 1
		else:
			selected_player = 3
		change_menu_color()
	elif Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0:
				get_tree().change_scene("res://scenes/MainBoard.tscn")
			1:
				match selected_player:
					0:
						if playerSettings[0][0] == ENUMS.PLAYER_TYPE.HUMAN:
							playerSettings[0][0] = ENUMS.PLAYER_TYPE.AI
							$HumanMarkRed.visible = false
							$AIMarkRed.visible = true
							optionalButtonRed = Color.gray
						else:
							playerSettings[0][0] = ENUMS.PLAYER_TYPE.HUMAN
							$HumanMarkRed.visible = true
							$AIMarkRed.visible = false
							optionalButtonRed = Color.webgray
					1:
						if playerSettings[1][0] == ENUMS.PLAYER_TYPE.HUMAN:
							playerSettings[1][0] = ENUMS.PLAYER_TYPE.AI
							$HumanMarkBlue.visible = false
							$AIMarkBlue.visible = true
							optionalButtonBlue = Color.gray
						else:
							playerSettings[1][0] = ENUMS.PLAYER_TYPE.HUMAN
							$HumanMarkBlue.visible = true
							$AIMarkBlue.visible = false
							optionalButtonBlue = Color.webgray
					2:
						if playerSettings[2][0] == ENUMS.PLAYER_TYPE.HUMAN:
							playerSettings[2][0] = ENUMS.PLAYER_TYPE.AI
							$HumanMarkGreen.visible = false
							$AIMarkGreen.visible = true
							optionalButtonGreen = Color.gray
						else:
							playerSettings[2][0] = ENUMS.PLAYER_TYPE.HUMAN
							$HumanMarkGreen.visible = true
							$AIMarkGreen.visible = false
							optionalButtonGreen = Color.webgray
					3:
						if playerSettings[3][0] == ENUMS.PLAYER_TYPE.HUMAN:
							playerSettings[3][0] = ENUMS.PLAYER_TYPE.AI
							$HumanMarkYellow.visible = false
							$AIMarkYellow.visible = true
							optionalButtonYellow = Color.gray
						else:
							playerSettings[3][0] = ENUMS.PLAYER_TYPE.HUMAN
							$HumanMarkYellow.visible = true
							$AIMarkYellow.visible = false
							optionalButtonYellow = Color.webgray
				change_menu_color()
			2:
				match selected_player:
					0:
						match $StrategyRed/Text.text:
							"SOLO":
								$StrategyRed/Text.text = "BALANCED"
								playerSettings[0][1] = ENUMS.AI_STRATEGY.BALANCED
							"BALANCED":
								$StrategyRed/Text.text = "RANDOM"
								playerSettings[0][1] = ENUMS.AI_STRATEGY.RANDOM
							"RANDOM":
								$StrategyRed/Text.text = "SOLO"
								playerSettings[0][1] = ENUMS.AI_STRATEGY.SOLO
					1:
						match $StrategyBlue/Text.text:
							"SOLO":
								$StrategyBlue/Text.text = "BALANCED"
								playerSettings[1][1] = ENUMS.AI_STRATEGY.BALANCED
							"BALANCED":
								$StrategyBlue/Text.text = "RANDOM"
								playerSettings[1][1] = ENUMS.AI_STRATEGY.RANDOM
							"RANDOM":
								$StrategyBlue/Text.text = "SOLO"
								playerSettings[1][1] = ENUMS.AI_STRATEGY.SOLO
					2:
						match $StrategyGreen/Text.text:
							"SOLO":
								$StrategyGreen/Text.text = "BALANCED"
								playerSettings[2][1] = ENUMS.AI_STRATEGY.BALANCED
							"BALANCED":
								$StrategyGreen/Text.text = "RANDOM"
								playerSettings[2][1] = ENUMS.AI_STRATEGY.RANDOM
							"RANDOM":
								$StrategyGreen/Text.text = "SOLO"
								playerSettings[2][1] = ENUMS.AI_STRATEGY.SOLO
					3:
						match $StrategyYellow/Text.text:
							"SOLO":
								$StrategyYellow/Text.text = "BALANCED"
								playerSettings[3][1] = ENUMS.AI_STRATEGY.BALANCED
							"BALANCED":
								$StrategyYellow/Text.text = "RANDOM"
								playerSettings[3][1] = ENUMS.AI_STRATEGY.RANDOM
							"RANDOM":
								$StrategyYellow/Text.text = "SOLO"
								playerSettings[3][1] = ENUMS.AI_STRATEGY.SOLO
			3:
				match selected_player:
					0:
						if playerSettings[0][2]:
							playerSettings[0][2] = false
							$OptionOneRed/Text.text = "ALWAYS HIT: OFF"
						else:
							playerSettings[0][2] = true
							$OptionOneRed/Text.text = "ALWAYS HIT: ON"
					1:
						if playerSettings[1][2]:
							playerSettings[1][2] = false
							$OptionOneBlue/Text.text = "ALWAYS HIT: OFF"
						else:
							playerSettings[1][2] = true
							$OptionOneBlue/Text.text = "ALWAYS HIT: ON"
					2:
						if playerSettings[2][2]:
							playerSettings[2][2] = false
							$OptionOneGreen/Text.text = "ALWAYS HIT: OFF"
						else:
							playerSettings[2][2] = true
							$OptionOneGreen/Text.text = "ALWAYS HIT: ON"
					3:
						if playerSettings[3][2]:
							playerSettings[3][2] = false
							$OptionOneYellow/Text.text = "ALWAYS HIT: OFF"
						else:
							playerSettings[3][2] = true
							$OptionOneYellow/Text.text = "ALWAYS HIT: ON"
			4:
				match selected_player:
					0:
						if playerSettings[0][3]:
							playerSettings[0][3] = false
							$OptionTwoRed/Text.text = "ALWAYS LEAVE: OFF"
						else:
							playerSettings[0][3] = true
							$OptionTwoRed/Text.text = "ALWAYS LEAVE: ON"
					1:
						if playerSettings[1][3]:
							playerSettings[1][3] = false
							$OptionTwoBlue/Text.text = "ALWAYS LEAVE: OFF"
						else:
							playerSettings[1][3] = true
							$OptionTwoBlue/Text.text = "ALWAYS LEAVE: ON"
					2:
						if playerSettings[2][3]:
							playerSettings[2][3] = false
							$OptionTwoGreen/Text.text = "ALWAYS LEAVE: OFF"
						else:
							playerSettings[2][3] = true
							$OptionTwoGreen/Text.text = "ALWAYS LEAVE: ON"
					3:
						if playerSettings[3][3]:
							playerSettings[3][3] = false
							$OptionTwoYellow/Text.text = "ALWAYS LEAVE: OFF"
						else:
							playerSettings[3][3] = true
							$OptionTwoYellow/Text.text = "ALWAYS LEAVE: ON"
			5:
				get_tree().quit()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
