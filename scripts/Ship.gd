extends RigidBody2D

func _ready():
	# get mass of child blocks
	
	#print_debug(get_children().size())
	
	var totalMass := 0.0;
	var totalXAdjMass := 0.0
	var totalYAdjMass := 0.0
	var xCenterOfMass = 0.0
	var yCenterOfMass = 0.0
	
	for block in get_children():
		#print(str(block.mass) + " " + str(block.position))
		totalMass += block.mass
		totalXAdjMass += block.mass * block.position.x
		totalYAdjMass += block.mass * block.position.y
	
	xCenterOfMass = totalXAdjMass / totalMass
	yCenterOfMass = totalYAdjMass / totalMass
	
	var centerOfMass := Vector2(xCenterOfMass, yCenterOfMass)
	print(centerOfMass)
	
	
	get_node("%indicator").position = position + centerOfMass
	center_of_mass = centerOfMass
	mass = totalMass
	
	
	var thrusters = get_tree().get_nodes_in_group("thruster")

	for thruster in thrusters:
		var force = thruster.get_node("force")
		force.forceLocation = centerOfMass + thruster.position
		
		#print(thruster.name)
		#print(force.vectorComponents)
		#print(force.forceLocation)
		force.set_process(true)
	
func _process(delta):
	#print_debug(str(rad_to_deg(rotation)).pad_decimals(1))
	#apply_force(Vector2(0, 30), center_of_mass + Vector2(15, 0))
	#print(rotation)
	# apply forces to thrusters based on keyboard inputs
	pass
