extends CanvasLayer

###############################################################################
# Scene that creates the fade-to-black transitions between rooms
###############################################################################

var scn = ""

# fade the screen
func fade_to(scn_path):
	self.scn = scn_path
	$AnimationPlayer.seek(0)
	$AnimationPlayer.play("fade")
	plot.paused = true

# change the scene when it's pitch black
func change_scene():
	if scn != "":
		get_tree().change_scene(scn)