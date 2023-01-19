extends Node2D

@export
var maxForce = 100000

var ship: RigidBody2D

@export
var forceLocation := Vector2.ZERO

@export
var vectorComponents := Vector2.ZERO

@export
var offsetAngle := 0.0

var force := Vector2.ZERO

var lastForce := Vector2.ZERO

var radius := 0.0


func _ready():
	# figure out which direction we go
	# these never change
	var vector = Vector2.RIGHT.from_angle(get_parent().rotation)
	var vectorX = str(vector.x).pad_decimals(2)
	var vectorY = str(vector.y).pad_decimals(2)
	vectorComponents = Vector2(float(vectorX), float(vectorY))
	
	#print(get_parent().name)
	#print(offsetAngle)
	#print(str(rad_to_deg(vectorComponents.angle())).pad_decimals(2))
	
	ship = get_parent().get_parent()
	
	radius = get_parent().position.length()
	
	set_process(false)
	# disable processing until ship populates needed variables
	

func _draw():
	return
	
	draw_line(Vector2.ZERO, Vector2(-100, 0), Color.BLUE, 3)
	if (force != Vector2.ZERO):
		#print(rad_to_deg(global_rotation))
		#print(force/100)
		draw_line(Vector2.ZERO, abs(force/1000), Color.RED, 3)
	
	# debug draw is in conflict with forces
	# because there is no way to apply a local force
	# and the draw always draws locally rather than globally
	# still, it should draw forces in the correct direction
	# but the best I can do is abs(force/100)



func _process(delta):
	

	var applyForce = false
	
	# listen to keyboard inputs, and apply forces to parent's parent
	# don't apply force unless a thruster faces in the right direction:
	# thruster faces the same way as the input direction
	
	if Input.is_action_pressed("backward") && vectorComponents.x < 0:
		applyForce = true

	if Input.is_action_pressed("forward") && vectorComponents.x > 0:
		applyForce = true

	if Input.is_action_pressed("left") && vectorComponents.y < 0:
		applyForce = true

	if Input.is_action_pressed("right") && vectorComponents.y > 0:
		applyForce = true

	var angle = global_rotation
	if applyForce:
		lastForce = force
		force = Vector2(cos(angle), sin(angle))
		force *= maxForce
		#print(rad_to_deg(global_rotation))
	else:
		force = Vector2.ZERO
	
	
	if applyForce:
		# turns out that using forceLocation causes buggy movement
		
		# however, using position doesn't apply any torque (rotation)
		ship.apply_force(force * delta, position)
		#ship.apply_torque()
		
		# rotate towards mouse or target
		# how to calculate torque
		# option: calculate when a thruster is off center
		# or just use forceLocation to determine this
		
		# from this, we know how far away we are from the center
		# find the force applied perpendicular to the forceLocation vector
		# find the components of the force that are perpendicular to the vector from position (0,0) and forceLocation 
		
		# find out the angle between these vectors
		var angularForce = force.length() * sin(offsetAngle)
		var torque = radius * angularForce
		ship.apply_torque(-torque/50)
		
		#todo:
		# thrusters should apply torque to follow mouse
		# how do other games handle this?
		
		#print(forceLocation.length())
		
		#get_global_mouse_position()
	queue_redraw()
	
	# todo: get the ship to rotate if a force is applied and it is not
	
	
	
	
	
	
	
	
	
	
	# it is so wobbly, and it doesn't follow the right angle when it should move straight but diagonally
	# it instead forces the ship towards some kind of pre-defined angle
	# the ships rotation should not be affected when flying straight!!
	
	
	
	
	
	# old stuff below:
	
	
	
	#var x_force := 0.0
	#var y_force := 0.0
	
	#force = Vector2(x_force, y_force).normalized()
	# really I don't need this
	
	
	
	
	
	# if it only has one (1,0) or (0,1), rotate it
	#var t = Transform2D()
	# = Transform2D(Vector2.ZERO)
	#t.rotation = force
	#force = t.rotated_local(ship.rotation).get_rotation()
	#force = ship.transform.basis_xform(force)
	# global_transform.basis_xform(force)

	
	#var force_local =  .xform(force)
	
	# if ship is facing up-left
	# forward thrusters should push at -145*, not 0*
	
	# furthermore, forward movement should not cause the ship to rotate
	
	# side thrusters are perpendicular, while forward thrusters are straight??
	
	# left thruster should not be rotated
	# but forward and back thrusters should be
	# all thrusters should be rotated
	
	# left thruster pushes down, so it doesn't need any rotation
	# but at an angle, it should make the ship move down
	
	
	
	
	# rear thruster pushes forwards
	# front thruster pushes backwards
	
	# if at an angle:
	# front and rear thrusters do not push at an angle
	
	# if left and right sides are unbalanced:
	# left and right thrusters cause spins while moving
	
	# I assume the left/right thrusters push up/down and
	# the offset from the center of mass causes the spin
	# this is the result of physics-based movement
	# or this might be a bug. When forward thrusters push at an angle, the ship doesn't spin
	
	# for the front and rear thrusters, I want them to push
	# in the direction of the ship
	
	
	# when thrusters should move without rotation, movement always causes rotation
	# this happens even when moving forwards / backwards
	# was caused by uncentered center of mass due to blocks not aligned with RigidBody origin
	# this will need to be fixed when building a ship at runtime
	
	
	
	
	#force = force.direction_to(Vector2.RIGHT.from_angle(ship.rotation))
	# this does not work, the ship wobbles and doesn't fly straight
	# I am not sure what this does
	# when it should rotate 360*, it only rotates up to +/-90* and then bounces back
	#var rotatedAngle = PI/2 + ship.rotation
	#force = force.rotated(rotatedAngle)
	
	#if get_parent().name == "Thruster":
	#	print(rad_to_deg(rotatedAngle))
	#var vector = Vector2.RIGHT.from_angle(ship.rotation)
	#force = force.from_angle(vector)
	#force = force.cross(vector)
	#if force != Vector2.ZERO:
		#print(get_parent().name)
	#	print(Vector2(x_force, y_force).normalized())
		#print(forceLocation)
	#	print(str(rad_to_deg(force.angle())).pad_decimals(2))
	
	#ship.rotation
	# also rotate this force in the direction the parent is already facing
	# currently, all forces are applied in the same direction that the thruster started in
	# instead, as the ship moves, the direction of the force should as well

	# this creates problems when the ship is moving and rotating when angled


	# apply a force in the direction that this thruster is facing
