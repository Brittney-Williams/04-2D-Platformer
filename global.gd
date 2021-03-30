extends Node

var save_data = {
	"level":1
	,"score":0
	,"timer":0
}

var save_file = "user://save.dat"
var key = "Voltron for the win!"

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):	
		var menu = get_node_or_null("/root/Game/UI/Menu")
		if menu != null:
			menu.show()
			get_tree().paused = true
		else:
			menu.hide()
			get_tree().paused = false

func increase_score(s):
	save_data["score"] += s
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_score()


func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass(save_file, File.WRITE, key)

	save_game.store_line(to_json(save_data))

	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()


func load_game():
	
	
	
	var save_game = File.new()
	if not save_game.file_exists(save_file):
		return 
	
	save_game.open_encrypted_with_pass(save_file, File.READ, key)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
 

	save_data = parse_json(save_game.et_line())
	increase_score(0)

	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line()) 
	
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])

	save_game.close()
	
	
	
