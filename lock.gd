class_name Lock
extends Node2D

func _ready() -> void:
	for p:LockPin in $Pins.get_children():
		p.condition_state_change.connect(_on_pin_condition_state_change.bind(p))
		var l = Label.new()
		l.text = str(p.type)
		l.add_theme_font_size_override("font_size",8)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.position = p.position-Vector2(3,0)
		l.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(l)

func _on_pin_condition_state_change(state:bool, which:LockPin) -> void:
	if state:
		which.modulate = Color("GREEN")
	else:
		which.modulate = Color("RED")

func _physics_process(_delta:float) -> void:
	var keypath = $Slot.node_a
	if keypath!=^"":
		var key = get_parent().get_node(str(keypath).split("/")[-1])
		if not key in $SnapArea.get_overlapping_bodies():
			print("not in the area")
			key.lock_rotation = false
			$Slot.node_a = ^""

func _on_snap_area_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.set.call_deferred("lock_rotation", true)
		body.rotation = 0
		$Slot.set.call_deferred("node_a",body.get_path())
