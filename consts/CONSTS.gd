class_name CONSTS

# colors of every player's fields
const FIELDS_COLORS = [
	Color8(255, 225, 53), Color8(216, 46, 63), Color8(53, 129, 216), Color8(40, 204, 45)
]

# colors of every player's pawns
const PAWNS_COLORS = [
	Color8(179, 155, 20), Color8(140, 15, 28), Color8(21, 77, 140), Color8(13, 128, 17)
]

# No of position on which player starts
const START_POSITIONS = [ 0, 10, 20, 30 ]

# coordinates of final fields for every player and every pawn
const FINAL_CORDS = [
	[Vector2(961, 634), Vector2(961, 728), Vector2(961, 821), Vector2(961, 915)], # player 1
	[Vector2(867, 541), Vector2(774, 541), Vector2(680, 541), Vector2(587, 541)], # player 2
	[Vector2(961, 447), Vector2(961, 354), Vector2(961, 260), Vector2(961, 167)], # player 3
	[Vector2(1054, 541), Vector2(1148, 541), Vector2(1241, 541), Vector2(1335, 541)] # player 4
]

# coordinates of home for every player and every pawn
const HOME_CORDS = [
	[Vector2(493, 914), Vector2(587, 914), Vector2(493, 1007), Vector2(587, 1007)], # player 1
	[Vector2(493, 73), Vector2(587, 73), Vector2(493, 167), Vector2(587, 167)], # player 2
	[Vector2(1334, 73), Vector2(1427, 73), Vector2(1334, 167), Vector2(1427, 167)], # player 3
	[Vector2(1334, 914), Vector2(1427, 914), Vector2(1334, 1007), Vector2(1427, 1007)] # player 4
]

# coordinates of every game field
const FIELDS_CORDS = [
	Vector2(867, 1008),
	Vector2(867, 915),
	Vector2(867, 821),
	Vector2(867, 728),
	Vector2(867, 634),
	Vector2(774, 634),
	Vector2(680, 634),
	Vector2(587, 634),
	Vector2(493, 634),
	Vector2(493, 541),
	Vector2(493, 447),
	Vector2(587, 447),
	Vector2(680, 447),
	Vector2(774, 447),
	Vector2(867, 447),
	Vector2(867, 354),
	Vector2(867, 260),
	Vector2(867, 167),
	Vector2(867, 73),
	Vector2(961, 73),
	Vector2(1054, 73),
	Vector2(1054, 167),
	Vector2(1054, 260),
	Vector2(1054, 354),
	Vector2(1054, 447),
	Vector2(1148, 447),
	Vector2(1241, 447),
	Vector2(1335, 447),
	Vector2(1428, 447),
	Vector2(1428, 541),
	Vector2(1428, 634),
	Vector2(1335, 634),
	Vector2(1241, 634),
	Vector2(1148, 634),
	Vector2(1054, 634),
	Vector2(1054, 728),
	Vector2(1054, 821),
	Vector2(1054, 915),
	Vector2(1054, 1008),
	Vector2(961, 1008)
]

# time frames of wait timers for ai moves
const MIN_START_GAME_WAIT_TIMER = 1.5
const MAX_START_GAME_WAIT_TIMER = 4.0
const MIN_ROLL_WAIT_TIMER = 0.2
const MAX_ROLL_WAIT_TIMER = 1.2
const MIN_MOVE_WAIT_TIMER = 0.5
const MAX_MOVE_WAIT_TIMER = 2.0

# debug prints
const IS_DEBUG = false
