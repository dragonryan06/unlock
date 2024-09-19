@tool
extends RigidBody2D

## I made some big mistakes with scaling and shit early on but I don't think it's worth fixing cause
## this is just for fun and we're on super limited time but uhhh yeah i definitely hardcoded some
## weird-ass values down there please pay them no mind!

@export_category("Generation Params")
@export var key_seed := 0.0 :
	set(new_seed):
		key_seed = new_seed
		generate_teeth()
@export var key_length := 1000 :
	set(new_len):
		key_length = new_len
		generate_teeth()
@export var key_resolution := 75 :
	set(new_res):
		key_resolution = new_res
		generate_teeth()
@export var key_amplitude := 1.0 :
	set(new_amp):
		key_amplitude = new_amp
		generate_teeth()

@export_category("PLEASE AVERT YOUR EYES GOOD LORD THIS IS SIN")
@export var key_leftmost_node := 186 :
	set(new_leftmost):
		key_leftmost_node = new_leftmost
		generate_teeth()
@export var key_top_offset := -167 :
	set(new_top_off):
		key_top_offset = new_top_off
		generate_teeth()

var mouse_hover = false
var mouse_drag = false

func _ready() -> void:
	$Handle.material = $Handle.material.duplicate()
	$Teeth.material = $Teeth.material.duplicate()
	generate_teeth()

func generate_teeth() -> void:
	if has_node("Teeth"):
		seed(key_seed)
		var poly = []
		poly.append(Vector2(key_length,key_top_offset))
		poly.append(Vector2(0,key_top_offset))
		poly.append(Vector2(0,key_leftmost_node))
		
		for i in range(key_resolution,key_length,key_resolution):
			poly.append(Vector2(i,randf_range(100.0,200.0)*key_amplitude))
		
		poly.append(Vector2(key_length,0))
		poly.append(Vector2(key_length,key_top_offset))
		$Teeth.set_polygon(PackedVector2Array(poly))
		$TeethBox.set_polygon(PackedVector2Array(poly))

func _input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_hover and event.is_pressed():
			mouse_drag = true
			freeze = true
		elif mouse_drag:
			mouse_drag = false
			freeze = false
			apply_central_impulse(Input.get_last_mouse_velocity())

func _physics_process(delta):
	if mouse_drag:
		var collision = move_and_collide(get_local_mouse_position())
		if collision != null and collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 80.0)


func _on_mouse_entered() -> void:
	$Handle.material.set_shader_parameter("blink",true)
	$Teeth.material.set_shader_parameter("blink",true)
	mouse_hover = true

func _on_mouse_exited() -> void:
	$Handle.material.set_shader_parameter("blink",false)
	$Teeth.material.set_shader_parameter("blink",false)
	mouse_hover = false
