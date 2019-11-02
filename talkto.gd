extends KinematicBody

###############################################################################
# NPC code! Lets you talk to other characters, and also determines some things
# for their dialogue and behavior
###############################################################################

var player = false
var agitated = true # whether the ghosts are calmed or not

export var knot = ""
export var ghost = false # is this a ghost?

# an array of what items the character has interactions with
export (Array, String) var iteminteractions = ["null"]

func _ready():
	# immediately destroy if this is a ghost that's already moved on
	if ghost && global.get(knot):
		queue_free()

func _process(_delta):
	# talk to the character
	if player == true && Input.is_action_just_pressed("ui_accept") && !plot.paused:
		if story.ChoosePathString(knot):
			plot.set_txt(story.Continue())
			if story.HasChoices:
				plot.buttonset = true
	# if the ghost is moving on, fade them out
	if ghost:
		if story.GetVariable(knot + "_disappear"):
			$AnimationPlayer2.play("fadeout")
			global.set(knot, true)
	# if the ghost is agitated, calm them
	if ghost && agitated:
		if !story.GetVariable(knot + "_agitated") && $Sprite3D.animation != "calm":
			$Sprite3D.animation = "calm"
			agitated = false

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player = true

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		player = false

# destroy after fading out (only applicable for ghosts!)
# not all npcs have this node, only ghosts, so this is dubious practice
func _on_AnimationPlayer2_animation_finished(anim_name):
	queue_free()

# item interactions
func _on_Area2_body_entered(body):
	if body.is_in_group("item"):
		for i in iteminteractions:
			if i == body.itemid:
				# item interaction variables all follow the name formula of npc_item
				story.SetVariable(knot + "_" + body.itemid, true)
