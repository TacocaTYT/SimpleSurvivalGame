extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 15
const JUMP_SPEED = 10
const ACCEL = 4.5

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper
var interactionPoint
var current_item
var UI_crosshair_off
var UI_crosshair_on
var Inv
var UIplaceholder
var allowProcesses
var placeRay
var buildMode
var playerUI

var craftWaiter = 0

var MOUSE_SENSITIVITY = 0.1

func _ready():
	#UIplaceholder = Inv
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	#anim = $AnimationPlayer
	interactionPoint = $Rotation_Helper/Camera/RayCast
	UI_crosshair_off = $Rotation_Helper/Camera/UI/CrosshairOff
	UI_crosshair_on = $Rotation_Helper/Camera/UI/CrosshairOn
	Inv = $Rotation_Helper/Camera/Inventory
	UIplaceholder = Inv
	placeRay = $Rotation_Helper/Camera/PlacementRayCast
	playerUI = $Rotation_Helper/Camera/UI
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	swing_axe()
	item_pickup()
	inventory_handler()
	if craftWaiter == 10:
		crafting_handler()
		craftWaiter = 0
	else:
		craftWaiter += 1

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("ui_up"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("ui_down"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("ui_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("ui_select"):
			vel.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	#if Input.is_action_just_pressed("ui_cancel"):
	#	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
	#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#	else:
	#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(-deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot



var woodCount = 0
var stoneCount = 0
var shroomCount = 0
var redShroomCount = 0
var grassCount = 0
var leafCount = 0
var pinetarCount = 0
var fabricCount = 0
var lumberCount = 0

func inventory_handler():
	if Input.is_action_just_pressed("invOpen"):
		if Inv.is_visible() or UIplaceholder.is_visible():
			playerUI.show()
		else:
			playerUI.hide()
		if Inv.is_visible() == true or UIplaceholder.is_visible() == true:
			Inv.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Inv.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pass
	var woodHolder = $Rotation_Helper/Camera/Inventory/woodHolder/woodLabel
	woodHolder.text = String(woodCount)
	var stoneHolder = $Rotation_Helper/Camera/Inventory/stoneHolder/stoneLabel
	stoneHolder.text = String(stoneCount)
	var grassHolder = $Rotation_Helper/Camera/Inventory/grassHolder/grassLabel
	grassHolder.text = String(grassCount)
	var fabricHolder = $Rotation_Helper/Camera/Inventory/CraftingMenu/fabricHolder/fabricLabel
	fabricHolder.text = String(fabricCount)
	var lumberHolder = $Rotation_Helper/Camera/Inventory/CraftingMenu/lumberHolder/lumberLabel
	lumberHolder.text = String(lumberCount)
	var redShroomHolder = $Rotation_Helper/Camera/Inventory/redShroomHolder/redShroomLabel
	redShroomHolder.text = String(redShroomCount)
	var shroomHolder = $Rotation_Helper/Camera/Inventory/brownShroomHolder/brownShroomLabel
	shroomHolder.text = String(shroomCount)
	pass



func swing_axe():
	if Input.is_action_pressed("attack"):
		$AnimationPlayer.play("Axe_Swing")


func item_pickup():
	if interactionPoint.is_colliding():
		UI_crosshair_off.hide()
		UI_crosshair_on.show()
	else:
		UI_crosshair_off.show()
		UI_crosshair_on.hide()
	if interactionPoint.is_colliding() and Input.is_action_just_pressed("interact"):
		var itemName = interactionPoint.get_collider().get_name()
		current_item = interactionPoint.get_collider().get_parent()
		if itemName == "wood":
			woodCount += 1
			current_item.queue_free()
		elif itemName == "stone":
			stoneCount += 1
			current_item.queue_free()
		elif itemName == "grass":
			grassCount += round(rand_range(1,3))
			current_item.queue_free()
		elif itemName == "redShroom":
			redShroomCount += 1
			current_item.queue_free()
		elif itemName == "shroom":
			shroomCount += 1
			current_item.queue_free()
		elif itemName == "planter":
			UIplaceholder = interactionPoint.get_collider().get_node("../UI")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			UIplaceholder.show()
			playerUI.hide()
		else:
			pass
		
		
		
		
func crafting_handler():
	if $Rotation_Helper/Camera/Inventory/CraftingMenu/fabricHolder/fabricCraft.is_pressed():
		if grassCount >= 4:
			fabricCount += 1
			grassCount -= 4
			print("crafted a fabric!")
	if $Rotation_Helper/Camera/Inventory/CraftingMenu/lumberHolder/lumberCraft.is_pressed():
		if woodCount >= 3:
			lumberCount += 1
			woodCount -=3
			print("crafted a lumber!")

func placement_handler():
	if buildMode:
		if Input.is_action_just_pressed("hotbarOne"):
			pass
		if Input.is_action_just_pressed("hotbarTwo"):
			pass
		if placeRay.is_colliding():
			pass
