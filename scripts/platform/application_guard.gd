extends Node
## Application state and fresh-input barrier. Added last so _input runs before HUD handlers.
var suspended: bool = false
var focused: bool = true
var resume_required: bool = false
var discard_next_step: bool = false
var _touches: Dictionary = {}
var _buttons: Dictionary = {}
var _keys: Dictionary = {}
var blocked: bool:
	get: return suspended or not focused

func observe(what: int) -> bool:
	match what:
		NOTIFICATION_APPLICATION_PAUSED:
			suspended = true
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_RESUMED:
			suspended = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true
		_:
			return false
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		resume_required = true
		discard_next_step = true
		_touches.clear()
		_buttons.clear()
		_keys.clear()
	return true

func acknowledge_resume() -> void:
	if not blocked:
		resume_required = false

func consume_return_step() -> bool:
	if blocked or not discard_next_step:
		return false
	discard_next_step = false
	return true

func _input(event: InputEvent) -> void:
	if blocked:
		get_viewport().set_input_as_handled()
		return
	var reject: bool = false
	if event is InputEventScreenTouch:
		if event.pressed:
			_touches[event.index] = true
		else:
			reject = not _touches.has(event.index)
			_touches.erase(event.index)
	elif event is InputEventScreenDrag:
		reject = not _touches.has(event.index)
	elif event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_MIDDLE]:
		var button_key: String = "%d:%d" % [event.device, event.button_index]
		if event.pressed:
			_buttons[button_key] = true
		else:
			reject = not _buttons.has(button_key)
			_buttons.erase(button_key)
	elif event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		reject = not _buttons.has("%d:%d" % [event.device, MOUSE_BUTTON_LEFT])
	elif event is InputEventKey:
		var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		if event.pressed and not event.echo:
			_keys[code] = true
		elif event.echo:
			reject = not _keys.has(code)
		else:
			reject = not _keys.has(code)
			_keys.erase(code)
	if reject:
		get_viewport().set_input_as_handled()
