extends Node

###############################################################################
# This is the plot and dialogue handler! It interfaces with the Ink story node
# and the GUI to print the current text to the dialogue box. All text goes
# through this before it shows up on-screen!
###############################################################################

# It might not be necessary to have both of these, but I'd have to go through the code.
var talking = false # is the box visible and talking?
var paused = false # handles cooldown mostly

var text = "" # the dialogue text

var i = 0 # how many letters are printed on-screen
var t = 0 # time counter
var quit = 0 # time counter for quitting (redundant?)
var quitting = false # cooldown helper for quitting dialogue, prevents dialogue loops
var buttonset = false # stores whether or not there are buttons

var panel # dialogue panel
var label # text in dialogue panel
var icon # icon for dialogue panel
#var anim #eventually to be used for cutscenes
var bbox # button container for dialogue panel
var btns = [] # buttons in dialogue panel

func _process(delta):
	t+= delta # increase time
	if talking:
		# prints text letter by letter
		if i <= text.length():
			if t > 0.01:
				label.set_text(text.left(i))
				i += 1
				t = 0
			# skips through letter-by-letter printing
			if Input.is_action_just_pressed("ui_accept"):
				i = text.length()
		
		# if all text is printed
		else:
			t = 0
			# show buttons
			if buttonset:
				buttons(story.CurrentChoices)
				buttonset = false
				panel.buttonshere()
			# continue text
			if Input.is_action_just_pressed("ui_accept"):
				if story.CanContinue:
					text = story.Continue()
					while story.CurrentText == "\n":
						text = story.Continue()
					if story.CurrentTags.size() > 0:
						set_portrait(story.CurrentTags[0])
					if story.HasChoices:
						buttonset = true
					i = 0
				# hack-y way to stop the progression of text if there are buttons
				elif story.HasChoices && story.CurrentChoices[0] != "break":
					pass
				# if this is the end of the text block, quit the dialogue
				else:
					i = 0
					talking = false
					quitting = true
					panel.hide()
					label.set_text("")
	# quit, prevents looping dialogue
	if quitting:
		quit += delta
		if quit >= 0.05:
			paused = false
			quitting = false
			quit = 0
			hide_buttons()
	
	# escape hatch until I can hunt down the looping dialogue bug
	if Input.is_action_just_pressed("ui_escapehatch"):
		i = 0
		talking = false
		quitting = true
		panel.hide()
		label.set_text("")

# get all of the GUI objects when changing the scene
func scene_change(room):
	panel = room.get_node("CanvasLayer/Panel")
	label = panel.get_node("HBoxContainer/VBoxContainer/Label")
	icon = panel.get_node("HBoxContainer/TextureRect")
	bbox = panel.get_node("HBoxContainer/VBoxContainer/HBoxContainer")
#	anim = room.get_node("plotanim") #eventually to be used for cutscenes
	btns = bbox.get_children()

# set the image portrait (boilerplate)
func set_portrait(imgname):
	icon.set_texture(load("res://chars/portraits/" + imgname + ".png"))
	# this has the extra effect of trying to load "null.png" if the dialogue isn't spoken by anyone
	# will be fixed later, but it works for now, even if the console yells about it

# start talking!
func set_txt(txt):
	panel.show()
	talking = true
	paused = true
	text = txt
	text = text.replace("\\n","\n")
	if story.CurrentTags.size() > 0:
		set_portrait(story.CurrentTags[0])

# set the Ink knot and determine if there are buttons
func set_knot(knot):
	if story.ChoosePathString(knot):
		set_txt(story.Continue())
		hide_buttons()
		while story.CurrentText == "\n":
			text = story.Continue()
		if story.HasChoices:
			buttonset = true

# pick a button choice
func pick_choice(no):
	i = 0
	story.ChooseChoiceIndex(no)
	while story.CurrentText == "\n":
		text = story.Continue()
	set_txt(story.CurrentText)
	hide_buttons()
	if story.HasChoices:
		buttonset = true

# show the same number of buttons as there are choices
func buttons(choices):
	if choices[0] != "break":
		for i in choices.size():
			btns[i].text = choices[i]
			btns[i].show()
			btns[i].set_disabled(false)
		btns[0].grab_focus()

# hide all buttons
func hide_buttons():
	for i in btns.size():
		btns[i].hide()
		btns[i].set_disabled(true)