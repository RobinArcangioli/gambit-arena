extends Node
## Own only raw touch sequences that start inside an active HUD scroll area.
## Physical mouse events retain the normal GUI path, including the wheel.
const DEADZONE: float = 12.0
const EMULATED_MOUSE: int = -1
var active_scrollers: Callable
var _finger_index: int = -1
var _scroller: ScrollContainer = null
var _button: BaseButton = null
var _start: Vector2 = Vector2.ZERO
var _origin: float = 0.0
var _area: Rect2 = Rect2()
var _dragged: bool = false
var _canceled: bool = false
var _suppress_emulated: bool = false

func _areas() -> Array[ScrollContainer]:
	var result: Array[ScrollContainer] = []
	if active_scrollers.is_valid():
		result.assign(active_scrollers.call())
	return result

func _pick(at: Vector2) -> ScrollContainer:
	for scroller in _areas():
		if is_instance_valid(scroller) and scroller.is_visible_in_tree() and scroller.get_global_rect().has_point(at):
			return scroller
	return null

func _find_button(node: Node, at: Vector2) -> BaseButton:
	# Only descendants in the content, never ScrollContainer's internal scrollbars.
	for child in node.get_children():
		if child is Control and child.is_visible_in_tree():
			if child is BaseButton and child.get_global_rect().has_point(at):
				return child
			var found: BaseButton = _find_button(child, at)
			if found != null:
				return found
	return null

func _valid_area() -> bool:
	return is_instance_valid(_scroller) and _scroller.is_visible_in_tree() and _scroller in _areas() and _scroller.get_global_rect() == _area

func _input(event: InputEvent) -> void:
	# The emulated mouse copy must never duplicate a tap handled here. Keep the
	# latch through release even if the tap opens a modal or changes the active list.
	if event is InputEventMouse and event.device == EMULATED_MOUSE:
		if _suppress_emulated or _pick(event.position) != null:
			get_viewport().set_input_as_handled()
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
				_suppress_emulated = event.pressed
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			if _finger_index >= 0:
				# A second finger cancels tap activation and cannot touch other buttons.
				_canceled = true
				get_viewport().set_input_as_handled()
				return
			_scroller = _pick(event.position)
			_suppress_emulated = _scroller != null
			if _scroller == null:
				return
			_finger_index = event.index
			_area = _scroller.get_global_rect()
			_start = _scroller.get_global_transform_with_canvas().affine_inverse() * event.position
			_origin = _scroller.scroll_vertical
			_button = _find_button(_scroller, event.position)
			_dragged = false
			_canceled = false
			get_viewport().set_input_as_handled()
		elif _finger_index >= 0:
			get_viewport().set_input_as_handled()
			if event.index != _finger_index:
				return
			_update_gesture(event.position)
			var activate: BaseButton = null
			if not event.canceled and not _canceled and not _dragged and _valid_area():
				if is_instance_valid(_button) and not _button.disabled and _button.is_visible_in_tree():
					if _scroller.is_ancestor_of(_button) and _area.has_point(event.position) and _button.get_global_rect().has_point(event.position):
						activate = _button
			# Release ownership before callbacks: an edit can synchronously open a modal.
			_finish()
			if activate != null:
				if activate.toggle_mode:
					activate.set_pressed(not activate.button_pressed)
				activate.pressed.emit()
	elif event is InputEventScreenDrag and _finger_index >= 0:
		get_viewport().set_input_as_handled()
		if event.index == _finger_index:
			_update_gesture(event.position)

func _update_gesture(at: Vector2) -> void:
	if not _valid_area():
		_canceled = true
		return
	var point_local: Vector2 = _scroller.get_global_transform_with_canvas().affine_inverse() * at
	var displacement: Vector2 = point_local - _start
	if displacement.length() > DEADZONE:
		_dragged = true
	if _dragged:
		var bar: VScrollBar = _scroller.get_v_scroll_bar()
		_scroller.scroll_vertical = roundi(clampf(_origin - displacement.y, bar.min_value, maxf(bar.min_value, bar.max_value - bar.page)))

func _finish() -> void:
	_finger_index = -1
	_scroller = null
	_button = null
	_dragged = false
	_canceled = false

func cancel_gesture() -> void:
	# Keep ownership until finger release, so a stale release cannot reach a button.
	if _finger_index >= 0:
		_canceled = true
		_button = null

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		cancel_gesture()
		# OS may not deliver the old release. New touches must remain usable on return.
		_finish()
		_suppress_emulated = false
