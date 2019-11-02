extends Spatial

###############################################################################
# Generic room code. Handles time events, saving/loading items, and the end of
# the demo event!
###############################################################################

var time = 12
var daynight = "Day"
export var room = ""

# name of array of items to save/load
var itemdict

func _ready():
	plot.scene_change(self)
	# teleport the player to wherever
	get_node("Container/Player").translation = global.teleportlocation
	# set the player's direction
	get_node("Container/Player/AnimatedSprite3D").animation = global.facing
	for i in inventory.items:
		get_node("CanvasLayer/ItemList").add_item(i.iname,i.img) 
	plot.paused = false
	itemdict = "items_" + room
	# if you've been to this room before, delete all items (so we don't get duplicates)
	# and then load all items from memory
	if global.get(room):
		var delete_nodes = get_tree().get_nodes_in_group("item")
		for i in delete_nodes:
			i.queue_free()
		var loading = global.get(itemdict)
		load_items(loading)
	# if this is your first time to the room, let the global script know
	else:
		global.set(room,true)

func _process(delta):
	# if all ghosts are complete, then run the finishing event!
	if global.logan && global.qyllia && !global.complete:
		global.complete = true
		global.player.translation
		# make four lavender items around the player
		for i in 4:
			var new_object = load("res://item.tscn").instance()
			match i:
				0:
					new_object.translation = Vector3(global.player.translation.x, 0, global.player.translation.z+1)
				1:
					new_object.translation = Vector3(global.player.translation.x, 0, global.player.translation.z-1)
				2:
					new_object.translation = Vector3(global.player.translation.x+1, 0, global.player.translation.z)
				3:
					new_object.translation = Vector3(global.player.translation.x-1, 0, global.player.translation.z)
			new_object.itemid = "lavender"
			new_object.iname = "Lavender"
			get_node("Container").add_child(new_object)

# add an hour to the time
func change_time():
	time += 1
	if time > 23:
		time = 0
	if time == 19:
		daynight = "Night"
	elif time == 7:
		daynight = "Day"
	get_node("CanvasLayer/Label").text = str(time,":00, ",daynight)

# save the items in the room
func save_room():
	var save_nodes = get_tree().get_nodes_in_group("item")
	global.clear_save(itemdict)
	for i in save_nodes:
		global.add_to_save(save_item(i),itemdict)

# save an individual item
func save_item(var item):
	var save_dict = {
			"itemid": item.itemid,
			"iname": item.iname,
			"pos": item.translation,
		}
	return save_dict

# load all items in the room
func load_items(var toload):
	for i in toload:
		var new_object = load("res://item.tscn").instance()
		new_object.translation = i["pos"]
		new_object.itemid = i["itemid"]
		new_object.iname = i["iname"]
		get_node("Container").add_child(new_object)