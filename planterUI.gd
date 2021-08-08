extends Control


# Declare member variables here. Examples:
var redShroom = load("res://textures/mushroom red.png")
var brownShroom = load("res://textures/mushroom.png")
var currentCrop
var newCrop
var updateCrop

#var redShroomButton
#var brownShroomButton

# Called when the node enters the scene tree for the first time.
func _ready():
	currentCrop = $cropHolder/cropIcon
	#redShroomButton = $redShroomHolder/redShroom
	#brownShroomButton = $brownShroomHolder/brownShroom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	plantingHandler()

func plantingHandler():
	if updateCrop == true:
		currentCrop.set_texture(newCrop)
		updateCrop = false
	if Input.is_action_just_pressed("invOpen"):
		if self.is_visible() == true:
			self.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_redShroom_button_up():
	newCrop = redShroom


func _on_brownShroom_button_up():
	newCrop = brownShroom


func _on_confirm_button_up():
	updateCrop = true
	
