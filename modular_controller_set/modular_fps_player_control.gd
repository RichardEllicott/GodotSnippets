"""

modular FPS control

ONLY INCLUDES CONTROLLER ITSELF, no gun etc


requires a child named "Camera" (set as active camera)


"""
extends KinematicBody

export var active = true # accept input events


export var speed = 9.0 # in meters/second
# ussain bolt  200m is 19.19 seconds... 10.42 m/s
# Florence Griffith Joyner 200m is  21.34 seconds... 9.37 m/s
# 9 m/s should not really be exceeded for realism

export var air_control = 0.3
export var crouch_speed = 2.0
export var acceleration = 8.0
export var jump = 4.5
export var mouse_sensitivity = 2.0



var direction = Vector3()
var velocity = Vector3()
var snap = Vector3()
var Y_velocity = 0.0


var current_speed = speed # current speed in context
var acceleration_factor = air_control

const GRAVITY = 9.8



export(NodePath) var _debug_label
onready var debug_label = get_node(_debug_label)


var camera # set to $Camera on ready



var initial_hit_points = 100.0
var hit_points = 100.0
var hit_points_recharge_rate = 1.0

func _input(event):

    if active:

        if event is InputEventMouseMotion:
            rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10.0
            camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10.0, -90.0, 90.0)


        direction.z = -Input.get_action_strength("ui_forward") + Input.get_action_strength("ui_back")

        direction.x = -Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right")


        direction = direction.normalized().rotated(Vector3.UP, rotation.y)

        if is_on_floor():

            if Input.is_action_just_pressed("ui_jump"):
                Y_velocity = jump
                snap = Vector3()

            if Input.is_action_just_pressed("ui_crouch"):
                current_speed = crouch_speed

            else:
                current_speed = speed



func _physics_process(delta):


    if is_on_floor() and not Input.is_action_just_pressed("ui_jump"):

        snap = Vector3.DOWN * 0.1
        Y_velocity = 0.0
        acceleration_factor = 1.0

    else: # we are in the air
        Y_velocity -= GRAVITY * delta
        acceleration_factor = air_control


    velocity.y = Y_velocity

    velocity = velocity.linear_interpolate(direction * current_speed, acceleration * acceleration_factor * delta)

    move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, deg2rad(45.0))

    if debug_label:
        debug_label.text = "velocity: %s" % [velocity.length()]






func _ready():

    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    camera = $Camera
