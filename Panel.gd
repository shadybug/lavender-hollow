extends Panel

###############################################################################
# This is the button handler for the dialogue panel!
###############################################################################

func _ready():
	global.panel = self

# grab focus if buttons are visible
func buttonshere():
		if !$HBoxContainer/VBoxContainer/HBoxContainer/Button.has_focus():
			$HBoxContainer/VBoxContainer/HBoxContainer/Button.grab_focus()

# tell the plot handler which button was pressed
func _on_Button_pressed():
	plot.pick_choice(0)
func _on_Button2_pressed():
	plot.pick_choice(1)
func _on_Button3_pressed():
	plot.pick_choice(2)
func _on_Button4_pressed():
	plot.pick_choice(3)
