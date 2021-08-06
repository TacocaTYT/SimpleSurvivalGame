extends StaticBody
const WoodPickup = preload("res://WoodPickup.tscn")

# Declare member variables here. Examples:
var health

# Called when the node enters the scene tree for the first time.
func _ready():
	#var anim = $AnimationPlayer
	health = 40
	randomize()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_area_entered(area):
	$AnimationPlayer.play("Tree_Hit")
	health -= 40
	if health < 1:
		var dropCount = round(rand_range(1, 9))
		while dropCount > 0:
			var wood_pickup = WoodPickup.instance()
			wood_pickup.transform.origin = transform.origin
			wood_pickup.set_linear_velocity(Vector3(rand_range(-5,5), rand_range(1,5), rand_range(-5,5)))
			get_parent().add_child(wood_pickup)
			dropCount -= 1
		queue_free()
