extends StaticBody

###############################################################################
# The Item scene provides a template for all items. Functionally, they're all
# the same aside from their names, description, reactions, and images, and the
# latter three are all determined by the item's ID.
###############################################################################

export var itemid = ""
export var iname = "" # "name" is already a godot variable

var itemtex # the item's texture/image
var knot # the Ink knot that contains the item's description

var player = false # is the player in the pickup area?

func _ready():
	if itemid != "":
		# sets the image based on itemid
		itemtex = "res://objects/items/" + itemid + ".png"
		$Sprite3D.texture = load(itemtex)
	knot = "item_" + itemid # sets the Ink knot based on itemid

func _process(_delta):
	# code to pick up the item
	if player == true && Input.is_action_just_pressed("ui_accept"):
		plot.set_knot(knot) # read the dialogue for the item
		inventory.items.append(inventory.InventoryItem.new(inventory.it.flower,iname,itemtex)) #TODO
		get_parent().get_parent().get_node("CanvasLayer/ItemList").add_item(iname,load(itemtex))                                                
		queue_free()

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player = true

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		player = false
