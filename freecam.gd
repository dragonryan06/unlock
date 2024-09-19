extends Camera2D

const POS_SPEED = 20
const ZOOM_STEP = 0.2
const ZOOM_SPEED = 0.001

var pos_velocity = Vector2(0.0,0.0)
var zoom_velocity = 0.0

var zoom_maxxed = false
var dragging = false

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		dragging = true
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		dragging = false
	
	if dragging and event is InputEventMouseMotion:
		position-=event.relative*Vector2(1.0/zoom.x,1.0/zoom.y)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(self,"zoom",zoom+Vector2(ZOOM_STEP,ZOOM_STEP)*zoom,ZOOM_SPEED).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tween.finished
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		if !zoom_maxxed:
			var tween = get_tree().create_tween().set_parallel()
			tween.tween_property(self,"zoom",zoom-Vector2(ZOOM_STEP,ZOOM_STEP)*zoom,ZOOM_SPEED).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await tween.finished

func _physics_process(delta):
	if Input.is_action_pressed("freecam_up"):
		pos_velocity.y-=POS_SPEED*1.0/zoom.x
	if Input.is_action_pressed("freecam_left"):
		pos_velocity.x-=POS_SPEED*1.0/zoom.x
	if Input.is_action_pressed("freecam_down"):
		pos_velocity.y+=POS_SPEED*1.0/zoom.x
	if Input.is_action_pressed("freecam_right"):
		pos_velocity.x+=POS_SPEED*1.0/zoom.x
	if Input.is_action_pressed("zoom_in"):
		zoom_velocity+=ZOOM_STEP*zoom.x*5.0
	if Input.is_action_pressed("zoom_out"):
		zoom_velocity-=ZOOM_STEP*zoom.x*5.0
	
	position+=pos_velocity*delta
	
	if zoom.x+zoom_velocity*delta<=0.01:
		zoom = Vector2(0.01,0.01)
		zoom_velocity = 0.0
	else:
		zoom+=Vector2(zoom_velocity,zoom_velocity)*delta
	
	if pos_velocity.x>0 and pos_velocity.x-0.5*POS_SPEED*1.0/zoom.x>0:
		pos_velocity.x-=0.5*POS_SPEED*1.0/zoom.x
	elif pos_velocity.x<0 and pos_velocity.x+0.5*POS_SPEED*1.0/zoom.x<0:
		pos_velocity.x+=0.5*POS_SPEED*1.0/zoom.x
	else:
		pos_velocity.x=0
	if pos_velocity.y>0 and pos_velocity.y-0.5*POS_SPEED*1.0/zoom.x>0:
		pos_velocity.y-=0.5*POS_SPEED*1.0/zoom.x
	elif pos_velocity.y<0 and pos_velocity.y+0.5*POS_SPEED*1.0/zoom.x<0:
		pos_velocity.y+=0.5*POS_SPEED*1.0/zoom.x
	else:
		pos_velocity.y=0
	
	if zoom_velocity>0 and zoom_velocity-0.5*ZOOM_SPEED>0:
		zoom_velocity-=0.5*ZOOM_SPEED
	elif zoom_velocity<0 and zoom_velocity+0.5*ZOOM_SPEED<0:
		zoom_velocity+=0.5*ZOOM_SPEED
	else:
		zoom_velocity = 0
	
	if 1.0/zoom.x<100:
		zoom_maxxed = false
	elif 1.0/zoom.x>=100:
		zoom_velocity=0
		zoom = Vector2(0.01,0.01)
		zoom_maxxed = true
