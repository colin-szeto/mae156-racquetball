# Objective: Drift a radius around the black/orange vessle 

radius_orbit = 1            # [meter] radius from the forward thruster to the black vessel
length_thrust = 21 * 0.0254 # [meter] distance between the forward and aft thrusters


aft_constant = radius_orbit/(radius_orbit + length_thrust) # how much more the aft thrusters need to thrust than the forward motor
forward_constant = (radius_orbit + length_thrust)/radius_orbit # how much more the aft thrusters need to thrust than the forward motor

print(str(aft_constant))
print(str(forward_constant))
