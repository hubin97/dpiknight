extends Area2D

func _on_body_entered(body):
	print("get")
	queue_free()
