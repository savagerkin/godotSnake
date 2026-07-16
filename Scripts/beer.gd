extends Area2D

var collected: bool = false


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return

	if not body.has_method("grow"):
		return

	collected = true

	body.grow()
	ScoreManager.add_score()

	queue_free()
