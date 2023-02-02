extends 'State.gd'

export var jumpStrength = 150
#Euler's method:
# https://www.youtube.com/watch?v=_0mvWedqW7c
# https://www.youtube.com/watch?v=BIz-wEu0QwE

#Verlet Integration
# https://www.algorithm-archive.org/contents/verlet_integration/verlet_integration.html

# Purpose of this approach is to simply tweak certain parameters, to better adjust to the type of jump we want to start
# By integrating twice, f''(t) = g, you will get the position function is  1/2*g*t^2 + v0*t + p0
# Let t(h) be the time it took to reach max height of jump, Given that f'(t) = g*t +v0, which represents velocity,
# This would mean f'(t(h)) = 0, thus v0 = -g*t(h) which represents the initial velocity of the jump in y direction
# Substituting for f(t) with f(t(h)) and v0 in the position function, you will get g = (-2*h) / t(h)^2 
# You can now substitute g into the v0 equation and get v0 = 2*h / t(h)

# Equations so far, t(h) represents time to reach max height
# v0 = 2*h/t(h) in y direction
# g = (-2*h) / t(h)^2

# Now if I wanted to do define intial jump velocity and gravity based on the velocity in x direction and how far I will jump, I can do substitution.
# To get t(h) based on the velocity in the x direction, we can do t(h) = x(h) / v(x), utilizing the distance over time formula.
# We can substitute t(h) into the equations above which gets us equations of how high and far we can jump based on initial velocity and gravity now:
# v0 = 2*h*v(x)/t(h)
# g = (-2*h*v(x)^2) / x(h)^2

# We will be using velocity verlet integration over euler integration because euler integration(method) can become inaccurate if the time it took to change from one frame to the next is fairly large.
# Euler method is : new velocity = current velocity + (rateOfChange) * stepSize, smaller the step size the smaller the rectangles you're making under the curve for integration
# Verlet integration is essentially a solution to the kinematic equation of any object
# https://www.algorithm-archive.org/contents/verlet_integration/verlet_integration.html
# https://www.youtube.com/watch?v=AZ8IGOHsjBk
# which ends up being simplified down to this form for numerical integration: 2*x(t) - x(t-deltaT) + a(t)deltaT^2
# In code this tranlastes to: position = 2*position -previousPosition + acceleration * changeInTime ^2
# However this only allows us to use position and acceleration, what if we wanted to calculate in terms of velocity?
# We can use velocity verlet which utilizes the kinematic equations
# since the acceleration is static, then the Velocity Verlet algorithm will produce the same results as the Euler algorithm,
# since the factor of 0.5 cancels out the difference in the acceleration term.
# However, the Velocity Verlet algorithm will still be symplectic,
# meaning that it will preserve the energy of the system. And hence why finalVelocity is  v = v0 *accel * dt


func enter(msg:={}):
	if msg.has("do_jump"):
		player.velocity.y = player.jumpVelocity
	
func physics_update(_delta: float):
	print(player.isNearWall())
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.velocity.x = direction * player.speed
	if Input.is_action_pressed("down"):
		player.velocity.y = -player.jumpVelocity
	if Input.is_action_just_released("up") && player.velocity.y < -300:
		player.velocity.y = -300

	var initialVelocity = player.velocity.y

	var finalVelocity = initialVelocity + player.getGravity() * _delta # final velocity using Verlet
	player.velocity.y = finalVelocity # update velocity
	player.move_and_slide(player.velocity, Vector2.UP) # apply movement

	if player.is_on_ceiling():
		player.velocity.y = -player.jumpVelocity / 10 
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x,0.0):
			state_machine.transition_to('Idle')
			
		else:
			state_machine.transition_to('Walk')
