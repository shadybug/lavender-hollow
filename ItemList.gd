extends ItemList

###############################################################################
# This ItemList is basically the inventory system. It keeps a list of all items
# and handles dropping them
###############################################################################

const itemResource = preload("res://item.tscn")

func _process(_delta):
	# open the item menu
	if Input.is_action_just_pressed("ui_menu"):
		visible = !visible
		get_tree().paused = !get_tree().paused
		# extra code to prevent unexpected behavior. Might recode later >:/
		if visible:
			grab_focus()
			set_process_input(true)
			select(0)
		if !visible:
			release_focus()
			set_process_input(false)
	
	# drop the selected item
	if Input.is_action_just_pressed("ui_accept"):
		if get_selected_items().size() > 0: # ensures you can't drop an item if there is no item selected
			var i = get_selected_items()[0] # only drop the first selected item (prevention against multiple selection)
			var item = itemResource.instance()
			item.iname = get_item_text(i)
			item.itemtex = get_item_icon(i).resource_path
			item.itemid = get_item_id(get_item_text(i))
			item.set_translation(global.player.get_translation() + global.player.get_node("facing").get_cast_to()) # drop in front of player
			get_parent().get_parent().get_node("Container").add_child(item)
			inventory.items.remove(i) # remove the item from the inventory
			remove_item(i) # remove the item from the item list

# get the item id from the item's name (will eventually just pass the item id into the 
func get_item_id(var s):
	s = s.to_lower()
	s = s.replace(" ","")
	return s