extends KinematicBody

###############################################################################
# IT'S YOU :D
###############################################################################

# walking speed (may make a run speed later)
const SPEED = 0.032

func _ready():
	global.player = self

func _physics_process(delta):
	# walk around! simple 4-directional movement
	var dir = Vector3()
	if !plot.paused:
		if Input.is_action_pressed("ui_left"):
			dir = Vector3(-1, 0, 0)
			$AnimatedSprite3D.animation = "left"
			$facing.set_cast_to(Vector3(-0.64,0,0))
		if Input.is_action_pressed("ui_right"):
			dir = Vector3(1, 0, 0)
			$AnimatedSprite3D.animation = "right"
			$facing.set_cast_to(Vector3(0.64,0,0))
		if Input.is_action_pressed("ui_up"):
			dir = Vector3(0, 0, -1)
			$AnimatedSprite3D.animation = "back"
			$facing.set_cast_to(Vector3(0,0,-0.64))
		if Input.is_action_pressed("ui_down"):
			dir = Vector3(0, 0, 1)
			$AnimatedSprite3D.animation = "front"
			$facing.set_cast_to(Vector3(0,0,0.64))
	dir = dir.normalized()
	move_and_collide(dir * SPEED)