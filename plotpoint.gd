extends Area

###############################################################################
# Plotpoints trigger dialogue/cutscenes when you walk into an area. Defunct for
# the time being
###############################################################################

export var knot = ""

func _on_plotpoint_body_entered(body):
	if body.is_in_group("player"):
		plot.set_knot(knot)
		queue_free()