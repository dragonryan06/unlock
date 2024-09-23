class_name LockPin
extends StaticBody2D

## A component representing the lock's individual pins, each in the lock is responsible for 
## determining if its condition has been met or not and reporting that to the lock.

signal condition_state_change(state:bool)

enum PIN_TYPE {
	DUMMY,
	PRESS,
	RELEASE
}

## DUMMY - this pin doesn't actually do anything; it can be pressed or released.
## PRESS - this pin must be pressed to open the lock.
## RELEASE - this pin shouldn't be pressed to open the lock.
@export var type = PIN_TYPE.DUMMY
## The length of the spring (in 20px-long coils) from the bottom of the pin
@export var spring_length = 1

var state = false

func _ready() -> void:
	for i in range(1,spring_length):
		var s = $Spring/SpringTile.duplicate()
		add_child(s)
		s.position += Vector2(0,40)*i
	
	if type == PIN_TYPE.DUMMY:
		condition_state_change.emit(true)

func _process(_delta:float) -> void:
	var cast = $RayCast2D.is_colliding()
	match type:
		PIN_TYPE.PRESS:
			if state != cast:
				state = cast
				condition_state_change.emit(state)
		PIN_TYPE.RELEASE:
			if state == cast:
				state = !cast
				condition_state_change.emit(state)
