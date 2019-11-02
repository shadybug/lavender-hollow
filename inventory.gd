extends Node

###############################################################################
# More advanced inventory code. Not actually functional for the time being, but
# the code is here for later use. Heavily based on this answer:
# https://godotengine.org/qa/30091/rpg-like-inventory-class-organization
###############################################################################

enum it {flower,object}
var items = []

class InventoryItem:
	var type
	var iname
	var img
	
	func _init(t, n, i):
		type = t
		iname = n
		img = load(i)
		
	func smell():
		if type == it.flower:
			print("Smells good! It's ", iname)
		elif type != it.flower:
			print("It doesn't smell like anything.")

func _ready():
	items = [ 
	InventoryItem.new(it.object, "Graveyard Dirt", "res://objects/items/graveyarddirt.png"),
	]
	
	for i in items:
		i.smell()