extends Node3D
## Passive procedural ice: no actors, damage, target selection or gameplay callbacks.
const Fade = preload("res://scripts/presentation/effect_fade.gd")
var envelope := Fade.new()
var age: float = 0
var strength: float = .8
var orbit: float = .34
var flight: float = .24
var source_id: int
var origin: Vector3
var bolts: Array[Dictionary] = []
var snapshots: Dictionary = {}

func paint(color: Color, opacity: float = 1) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.vertex_color_use_as_albedo = true
	material.albedo_color = Color(color, opacity)
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = .5 + strength
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	return material

func crystal(length: float, width: float, seed_index: int) -> ArrayMesh:
	var surface := SurfaceTool.new(); surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var points: Array[Vector3] = [Vector3(0, 0, -length * .72)]
	for i in range(5):
		var angle: float = TAU * i / 5.0
		points.append(Vector3(cos(angle) * width, sin(angle) * width, length * .05))
	points.append(Vector3(.018, -.015, length * .28))
	for face in range(10):
		var i: int = face % 5
		var indices: Array = [0, i + 1, (i + 1) % 5 + 1] if face < 5 else [6, (i + 1) % 5 + 1, i + 1]
		var colors: Array = [Color("d9faff"), Color("2a8fd5"), Color("83dfff"), Color("edfaff"), Color("13528c")]
		for index in indices:
			surface.set_color(colors[(i + seed_index) % colors.size()]); surface.add_vertex(points[index])
	surface.generate_normals()
	return surface.commit()

func setup(event: Dictionary, intensity: float) -> void:
	strength = intensity; source_id = int(event.source_id); origin = event.source_position
	orbit = float(event.orbit_duration); flight = float(event.flight_duration)
	for index in range(3):
		var mesh := MeshInstance3D.new(); mesh.mesh = crystal(.50 + strength * .22, .080 + strength * .030, index)
		mesh.material_override = paint(Color("b3eaff")); mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(mesh)
		var spine := MeshInstance3D.new(); spine.mesh = crystal(.50, .014, 0)
		spine.material_override = paint(Color("ecfcff"), .6 + minf(.4,strength*.3))
		mesh.add_child(spine); spine.position = Vector3(.012,.063,-.04)
		# A smaller offset splinter breaks the silhouette of the large faceted shard.
		var splinter := MeshInstance3D.new(); splinter.mesh = crystal(.30, .035, index + 2)
		mesh.add_child(splinter); splinter.position = Vector3(.10, .045, .13); splinter.rotation.z = .4
		var ribbon := MeshInstance3D.new(); ribbon.material_override = paint(Color("6bbcff"), .55 * strength)
		ribbon.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF; add_child(ribbon)
		var victim: Dictionary = event.victims[index] if index < event.victims.size() else {}
		var shards: Array[MeshInstance3D] = []
		for chip in range(8):
			var part := MeshInstance3D.new(); part.mesh = crystal(.12, .025, chip)
			part.material_override = paint(Color("c3f2ff"), 0); part.hide(); add_child(part); shards.append(part)
		bolts.append({"mesh":mesh,"ribbon":ribbon,"shards":shards,"target_id":victim.get("target_id",0),"destination":victim.get("target_position",origin),"impact":false,"hit_age":0.0,"history":[],"position":orbit_position(index,0)})
	advance_visual({}, 0)

func orbit_position(index: int, progress: float) -> Vector3:
	var angle: float = TAU * index / 3.0 + progress * TAU * .72
	return origin + Vector3(cos(angle) * .48, 1.35 + sin(angle * 1.4) * .10, sin(angle) * .38)

func impact(index: int, at: Vector3, hit: bool) -> void:
	if index < 0 or index >= bolts.size(): return
	var bolt: Dictionary = bolts[index]
	bolt.impact = true; bolt.hit_age = 0.0; bolt.destination = at + Vector3.UP * .55
	bolt.hit = hit; bolt.mesh.hide(); bolt.ribbon.hide()

func advance_visual(values: Dictionary, dt: float) -> void:
	age += maxf(0, dt); snapshots = values
	if age <= orbit and values.has(source_id): origin = values[source_id].position
	for index in range(bolts.size()):
		var bolt: Dictionary = bolts[index]
		if bolt.impact:
			bolt.hit_age += maxf(0, dt)
			var progress: float = clampf(bolt.hit_age / .30, 0, 1)
			for chip in range(bolt.shards.size()):
				var part: MeshInstance3D = bolt.shards[chip]
				part.visible = progress < 1
				var angle: float = TAU * chip / 8.0 + index
				var direction := Vector3(cos(angle), .3 + .4 * sin(chip * 2.1), sin(angle))
				part.position = bolt.destination + direction * progress * (.46 if bolt.get("hit",true) else .22)
				part.rotation = Vector3(chip + progress * 4, angle, progress * 3)
				part.scale = Vector3.ONE * (1.0 - progress * .7)
				part.material_override.albedo_color.a = envelope.sample(progress) * strength
			continue
		var previous: Vector3 = bolt.position
		if age <= orbit:
			bolt.position = orbit_position(index, age / orbit)
			bolt.mesh.position = bolt.position
			var tangent := Vector3(-sin(TAU * index / 3.0 + age / orbit * TAU * .72), .15, cos(TAU * index / 3.0 + age / orbit * TAU * .72))
			bolt.mesh.look_at(bolt.position + tangent, Vector3.UP)
		else:
			if int(bolt.target_id) == 0:
				impact(index, previous - Vector3.UP * .55, false); continue
			if values.has(bolt.target_id): bolt.destination = values[bolt.target_id].position
			var progress: float = clampf((age - orbit) / flight, 0, 1)
			var start: Vector3 = orbit_position(index, 1)
			var end: Vector3 = bolt.destination + Vector3.UP * .55
			bolt.position = start.lerp(end, progress) + Vector3.UP * sin(progress * PI) * .18
			bolt.mesh.position = bolt.position
			if bolt.position.distance_squared_to(end) > .000001: bolt.mesh.look_at(end, Vector3.UP)
			if age > orbit + flight + .12: impact(index, bolt.destination, false)
		bolt.mesh.rotate_z(dt * 12)
		bolt.history.append(bolt.position)
		while bolt.history.size() > 7: bolt.history.pop_front()
		_draw_trail(bolt)

func _draw_trail(bolt: Dictionary) -> void:
	if bolt.history.size() < 2: return
	var surface := SurfaceTool.new(); surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(1, bolt.history.size()):
		var a: Vector3 = bolt.history[i-1]; var b: Vector3 = bolt.history[i]
		var width: float = .045 * float(i) / bolt.history.size() * strength
		var side: Vector3 = (b-a).cross(Vector3.UP).normalized() * width
		for point in [a-side, a+side, b+side, a-side, b+side, b-side]:
			surface.set_color(Color(.45,.8,1,float(i)/bolt.history.size() * .5)); surface.add_vertex(point)
	bolt.ribbon.mesh = surface.commit()
