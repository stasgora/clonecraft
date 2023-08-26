extends Marker3D

signal selected_object(object: Node3D)


func _process_cursor():
	var ray_collider = $CursorRayCast.get_collider()
	if not ray_collider:
		return
	selected_object.emit(ray_collider)

	if Input.is_action_just_pressed("destroy"):
		pass
	if Input.is_action_just_pressed("place"):
		var pos = ray_collider.position + $CursorRayCast.get_collision_normal()
		#get_tree().get_root().get_node("Root/World").spawn_block("grass_block", pos)


func _physics_process(_delta):
	_process_cursor()
