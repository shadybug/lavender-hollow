extends StaticBody

###############################################################################
# The Door scene provides a way to go to/from scenes, and calls the functions
# needed to save them.
###############################################################################

export var nextscene = "" # the scene the door leads to
export var telecation = Vector3(0,0,0) # the location in the next scene that the door leads to
# (allows us to have multiple doors that lead to the same room)

# Called when something has entered the door's collision area
func _on_Area_body_entered(body):
	if body.is_in_group("player") && !plot.paused:
		global.teleportlocation = telecation # set the teleport location to a global variable, so the next scene can access it
		global.facing = get_parent().get_node("Player/AnimatedSprite3D").animation # make sure the player is still facing the same direction
		get_parent().get_parent().save_room() # save the item locations in the room
		transitionfade.fade_to(nextscene)