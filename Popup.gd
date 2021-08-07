extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_on_Popup_mouse_entered()
	#_on_Popup_mouse_exited()


func _on_Popup_mouse_entered():
	#self.show()
	self.popup()


#func _on_Popup_mouse_exited():
	#self.hide()
