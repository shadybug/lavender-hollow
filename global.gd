extends Node

###############################################################################
# This is the global variable storage, that allows things to persist through 
# scenes. Variables and basic functions only!
###############################################################################

var inventory = {} # inventory system, kind of moot for the time being

# FOR TRANSITIONING BETWEEN SCENES
var teleportlocation = Vector3(-1,0,0) # the location the player will be when they exit a door to the next scene
var facing = "front" # the direction the player should be facing in the next scene

# For determining if the player has been to a room before (so it knows if it should spawn initial items)
var graveyard = false
var summoning = false
var mainfloor = false
var attic = false

# Saving/Loading arrays to contain saved item dictionaries, for loading when reentering a scene
var items_graveyard = []
var items_summoning = []
var items_mainfloor = []
var items_attic = []
################################

# DEMO COMPLETION VARIABLES
var complete = false

# for determining if these ghosts have disappeared
var logan = false
var qyllia = false
var tien = false
################################

# GLOBAL OBJECTS
# might not be good practice? but it helps me keep track of necessary objects in the scene
var player
var room
var panel
################################

# TIME AND EVENTS
var time = 11 # the time of day (defaults to 11am, as the animation increments it to 12pm immediately)
################################

# Adds item dictionaries to the saving/loading arrays. There's probably a way
# better way to do this, but I had trouble accessing arrays from strings.
func add_to_save(var item, var variable):
	match variable:
		"items_graveyard":
			items_graveyard.append(item)
		"items_summoning":
			items_summoning.append(item)
		"items_mainfloor":
			items_mainfloor.append(item)
		"items_attic":
			items_attic.append(item)

# Clears the saving/loading arrays, so items don't stay in saved memory if
# they're picked up. See above
func clear_save(var variable):
	match variable:
		"items_graveyard":
			items_graveyard.clear()
		"items_summoning":
			items_summoning.clear()
		"items_mainfloor":
			items_mainfloor.clear()
		"items_attic":
			items_attic.clear()