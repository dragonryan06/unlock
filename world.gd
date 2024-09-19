extends Node2D

var Key = preload("res://key.tscn")
var rand = RandomNumberGenerator.new()

func _ready() -> void:
	rand.randomize()

func _input(event) -> void:
	seed(randf())
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
		var k = Key.instantiate()
		k.global_position = get_global_mouse_position()
		k.key_seed = rand.randi()
		k.key_amplitude = rand.randf_range(1.0,2.0)
		k.key_length = rand.randi_range(750,1250)
		k.key_resolution *= (float(k.key_length)/1000.0)
		k.modulate = Color(randf_range(0.0,1.0),randf_range(0.0,1.0),randf_range(0.0,1.0))
		add_child(k)
