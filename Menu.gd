extends TextureRect

###############################################################################
# This is the button handler for the main menu!
###############################################################################

func _ready():
	# grab focus on the start button
	$VBoxContainer/VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	# start the game
	transitionfade.fade_to("res://Summoning.tscn")

func _on_Credits_pressed():
	# show credits
	$Panel.show()
	$Panel/VBoxContainer/Back.grab_focus()

func _on_Back_pressed():
	# hide credits
	$Panel.hide()
	$VBoxContainer/VBoxContainer/Credits.grab_focus()