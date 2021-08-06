extends StaticBody
const StonePickup = preload("res://StonePickup.tscn")

# Declare member variables here. Examples:
var health

# Called when the node enters the scene tree for the first time.
func _ready():
	#var anim = $AnimationPlayer
	health = 20
	randomize()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_area_entered(area):
	$AnimationPlayer.play("Tree_Hit")
	health -= 20
	if health < 1:
		var dropCount = round(rand_range(1, 3))
		while dropCount > 0:
			var stone_pickup = StonePickup.instance()
			stone_pickup.transform.origin = transform.origin + Vector3(0, .5, 0)
			stone_pickup.set_linear_velocity(Vector3(rand_range(-5,5), rand_range(1,5), rand_range(-5,5)))
			get_parent().add_child(stone_pickup)
			dropCount -= 1
		queue_free()
