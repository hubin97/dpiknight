extends Area2D

func _on_body_entered(body):
	print("get")
	print(body)
	queue_free()
