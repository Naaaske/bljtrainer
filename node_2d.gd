extends Node2D

var aCounter = 0 #A presses in current cycle so far
var going = false #Whether a cycle is going
var mode8 = true #Whether to use 1-4-6 or 1-4-8
var t = 0 #Time since first a press in seconds
var simulatedFrameRate = 30 
var spf = 1.0 / simulatedFrameRate #Seconds per simulated frame
var pressed = false #Has A been pressed this frame

var white = Color.html("#f8f8f2")
var green = Color.html("#50fa7b")
var red = Color.html("#ff5555")

func _ready():
	$ModeButton.pressed.connect(self.changeMode)
	$Audio.stream = load("res://148.wav")

func _process(_delta):
	pressed = Input.is_action_just_pressed("A")
	
	#Reset if a second has passed since cycle start
	if(t > 1):
		resetCycle()
	
	#If a is pressed
	if (pressed):
		aCounter += 1

		if (aCounter == 1):
			going = true
			t = 0
			$Audio.play()
			
			$First.text = str(getFramesSinceStart())
		
		elif (aCounter == 2):
			updateLabel($Second, 4)
		
		elif (aCounter == 3):
			updateLabel($Third, 8 if mode8 else 6)
		
		elif (aCounter == 4):
			$Last.text = str(getFramesSinceStart())

	#Update Frame counter
	$Frames.text = str(getFramesSinceStart())
	
	if(going):
		t += _delta

func changeMode():
	mode8 = !mode8
	$Audio.stream = load("res://148.wav") if mode8 else load("res://146.wav")
	$ModeButton.text = "Mode: " + ("1-4-8" if mode8 else "1-4-6")

func getFramesSinceStart():
	if(!going): return 0
	
	return floor(t / spf) + 1

func updateLabel(label : Label, targetFrame):
	label.text = str(getFramesSinceStart())
	if (getFramesSinceStart() == targetFrame):
		label.add_theme_color_override("font_color", green)
	else:
		label.add_theme_color_override("font_color", red)
		label.get_child(0).text = ("+" if getFramesSinceStart() - targetFrame > 0 else "") + str(getFramesSinceStart() - targetFrame)

func resetCycle():
	going = false
	t = 0
	aCounter = 0
	$First.text = "_"
	$First.add_theme_color_override("font_color", white)
	$Second.text = "_"
	$Second.add_theme_color_override("font_color", white)
	$Second/Delta.text = ""
	$Third.text = "_"
	$Third.add_theme_color_override("font_color", white)
	$Third/Delta.text = ""
	$Last.text = "_"
