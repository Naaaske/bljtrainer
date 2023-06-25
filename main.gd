extends Node2D

var aCounter = 0 #A presses in current cycle so far
var going = false #Whether a cycle is going
var mode8 = true #Whether to use 1-4-6 or 1-4-8
var t = 0.0 #Time since first a press in seconds
var pressed = false #Has A been pressed this frame
var enableAudio = true 
var simulatedFrameRate = 30 
var spf = 1.0 / simulatedFrameRate #Seconds per simulated frame

func _process(delta):
	pressed = Input.is_action_just_pressed("A")
	
	#Reset if a second has passed since cycle start
	if(t > 1):
		resetCycle()
	
	#If a is pressed
	if (pressed):
		aCounter += 1
		
		if (!going):
			going = true
			t = 0.0
			if enableAudio: $Audio.play()
		
		if (aCounter == 1):
			updateLabel($First)
		
		elif (aCounter == 2):
			updateLabel($Second, 4)
		
		elif (aCounter == 3):
			updateLabel($Third, 8 if mode8 else 6)
		
		elif (aCounter == 4):
			updateLabel($Last)

	#Update Frame counter
	$Frames.text = str(framesSinceStart())
	
	if(going):
		t += delta

func framesSinceStart() -> int:
	if(!going): return 0
	
	return floor(t / spf) + 1

func updateLabel(label : Label, targetFrame = 0):
	label.text = str(framesSinceStart())
	
	if(targetFrame == 0): return
	
	if (framesSinceStart() == targetFrame):
		label.add_theme_color_override("font_color", Color.html("#50fa7b"))
	else:
		label.add_theme_color_override("font_color", Color.html("#ff5555"))
		if (label.get_child_count() > 0):
			label.get_child(0).text = ("+" if framesSinceStart() - targetFrame > 0 else "") + str(framesSinceStart() - targetFrame)

func resetLabel(label : Label):
	label.text = "_"
	label.add_theme_color_override("font_color", Color.html("#f8f8f2"))
	if (label.get_child_count() > 0):
		label.get_child(0).text = ""

func resetCycle():
	going = false
	t = 0
	aCounter = 0
	resetLabel($First)
	resetLabel($Second)
	resetLabel($Third)
	resetLabel($Last)

func _on_mode_button_pressed():
	mode8 = !mode8
	$Audio.stream = load("res://Audio/148.wav") if mode8 else load("res://Audio/146.wav")
	$ModeButton.text = "Mode: " + ("1-4-8" if mode8 else "1-4-6")

func _on_audio_toggle_button_down():
	enableAudio = !enableAudio
	$AudioToggle.icon = load("res://Images/audioIconOn.png") if enableAudio else load("res://Images/audioIconOff.png")
