extends Node
var score: int =0

func set_score(score: int) -> void:
	self.score = score

func get_score() -> int:
	return score

func add_score()-> void:
	score += 1
