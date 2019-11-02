extends StaticBody

###############################################################################
# Signposts are any stationary dialogue element (signs, graves, bookshelves,
# etc.
###############################################################################

var player = false

# Ink knot, type of object, and style (for gravestones mostly)
export var knot = ""
export var type = ""
export var style = 0

func _ready():
	# randomize the gravestones (unless specified otherwise)
	# in future versions, this will be manual instead of randomized
	if type == "gravestone":
		match style:
			0:
				randomize()
				if randf() > 0.75:
					$MeshInstance.show()
				elif randf() > 0.5:
					$MeshInstance2.show()
				elif randf() > 0.25:
					$MeshInstance3.show()
				else:
					$MeshInstance4.show()
			1:
				$MeshInstance.show()
			2:
				$MeshInstance2.show()
			3:
				$MeshInstance3.show()
			4:
				$MeshInstance4.show()

func _process(_delta):
	# whoa that's a lot of &&s
	if player == true && Input.is_action_just_pressed("ui_accept") && !plot.paused && knot != "":
		if story.ChoosePathString(knot):
			plot.set_txt(story.Continue())
			if story.HasChoices:
				plot.buttonset = true

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player = true

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		player = false
