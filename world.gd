extends Node2D

var Key = preload("res://key.tscn")
var rand = RandomNumberGenerator.new()

@export var possible_key_colors : GradientTexture1D

func _ready() -> void:
	rand.randomize()
	for c in $SettingsPanel/MarginContainer/VBoxContainer/GridContainer.get_children():
		if c is LineEdit:
			c.text_submitted.connect(_on_generation_setting_text_submitted.bind(c))

func _input(event) -> void:
	seed(randi())
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
		var k = Key.instantiate()
		k.global_position = get_global_mouse_position()
		var settings = $SettingsPanel/MarginContainer/VBoxContainer/GridContainer
		for c in settings.get_children():
			if c is LineEdit and c.text == "r":
				match c.get_meta("varname"):
					"key_seed":
						k.key_seed = rand.randi()
					"key_amplitude":
						k.key_amplitude = rand.randf_range(1.0,2.0)
					"key_length":
						k.key_length = rand.randi_range(750,1250)
					"key_resolution":
						k.key_resolution *= (float(k.key_length)/1000.0)
			elif c is LineEdit:
				match c.get_meta("varname"):
					"key_seed", "key_length":
						k.set(c.get_meta("varname"),int(c.text))
					"key_amplitude", "key_resolution":
						k.set(c.get_meta("varname"),float(c.text))
		k.modulate = possible_key_colors.gradient.sample(randf_range(0.0,1.0))
		add_child(k)

func _on_generation_setting_text_submitted(new_text: String, which:LineEdit) -> void:
	if new_text!="r" and !new_text.is_valid_float() and !new_text.is_valid_int():
		which.text = str(Key.instantiate().defaults[which.get_meta("varname")])
