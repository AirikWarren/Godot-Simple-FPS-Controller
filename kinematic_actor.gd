extends KinematicBody

const GRAVITY : float = 9.8

export var view_sensitivity : float = 0.3 
export var gravity_multiplier : float = 1.0 
export var max_speed : float = 15.0
export var acceleration_rate : float = 1.15
export var deceleration_rate : float = 5.0
export var max_slope_angle : float = 40
# provided only as a fallback to project input map, not extensively tested / supported
export var alternative_input_map : Dictionary = {
	"move_forwards" : "W",
	"move_backwards" : "A",
	"move_left" : "S",
	"move_right" : "D",
}

var _pitch : float = 0.0
var _yaw : float = 0.0
var _velocity : Vector3 = Vector3()

onready var YawSpatial : Spatial = $Spatial_camera_yaw
onready var PlayerCamera : Camera = $Spatial_camera_yaw/Camera_player
# Vars below only used for debug
onready var VelocityLabel : Label = $Spatial_camera_yaw/Camera_player/Label_velocity
onready var PitchLabel : Label = $Spatial_camera_yaw/Camera_player/Label_pitch
onready var YawLabel : Label = $Spatial_camera_yaw/Camera_player/Label_yaw

func _enter_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready() -> void:
	set_physics_process(true)
	set_process_input(true)

	# maps the alternative input map strings to their respective scan codes
	for k in alternative_input_map.keys():
		alternative_input_map[k] = ord(alternative_input_map[k])

func _physics_process(delta):
	var goal_velocity : Vector3 = Vector3()
	var h_velocity : Vector3 = _velocity # temporary variable only used in scope of this function, used to update _velocity
	var direction_vector : Vector3 = _get_movement_direction()

	_velocity.y += -(GRAVITY * gravity_multiplier) * delta

	h_velocity.y = 0

	goal_velocity = direction_vector * max_speed

	if direction_vector.dot(h_velocity) > 0:
		h_velocity = h_velocity.linear_interpolate(goal_velocity, acceleration_rate * delta) 
	else:
		h_velocity = h_velocity.linear_interpolate(goal_velocity, deceleration_rate * delta) 

	_velocity.x = h_velocity.x
	_velocity.z = h_velocity.z
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4)
	_print_debug_info()	
	
func _unhandled_input(event) -> void:
	if event.get_class() == "InputEventMouseMotion":
		_handle_mouse_input(event)

func _handle_mouse_input(event : InputEvent) -> void:
	_yaw = fmod(_yaw - event.relative.x * view_sensitivity, 360)
	_pitch = max(min(_pitch - event.relative.y * view_sensitivity, 90), -90)
	YawSpatial.set_rotation(Vector3(0, deg2rad(_yaw), 0))
	PlayerCamera.set_rotation(Vector3(deg2rad(_pitch), 0, 0))

func _get_movement_direction() -> Vector3:
	var movement_direction = Vector3()

	if Input.is_action_pressed("move_forwards") or Input.is_key_pressed(alternative_input_map["move_forwards"]):
		movement_direction -= PlayerCamera.global_transform.basis.z
	if Input.is_action_pressed("move_backwards") or Input.is_key_pressed(alternative_input_map["move_backwards"]):
		movement_direction += PlayerCamera.global_transform.basis.z
	if Input.is_action_pressed("move_left") or Input.is_key_pressed(alternative_input_map["move_left"]):
		movement_direction -= PlayerCamera.global_transform.basis.x
	if Input.is_action_pressed("move_right") or Input.is_key_pressed(alternative_input_map["move_right"]):
		movement_direction += PlayerCamera.global_transform.basis.x

	return movement_direction.normalized()

func _print_debug_info() -> void:
	PitchLabel.text = "Pitch: %f" % _pitch
	YawLabel.text = "Yaw: %f" % _yaw
	VelocityLabel.text = "Velocity: %s" % _velocity
