extends Area2D



func _on_body_entered(_body: Node2D) -> void:
	ScoreManager.add_score()
	queue_free()
