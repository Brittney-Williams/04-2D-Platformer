extends Area2D

export var score = 10

# Called when the node enters the scene tree for the first time.
func save():
	 var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"score" : score
	}
	return save_dict



func _on_Coin_body_entered(body):
	if body.name == "Player":
		Global.increase_score(score)
		queue_free()
