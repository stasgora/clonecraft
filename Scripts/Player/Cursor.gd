extends Marker3D

signal selected_object(object: Node3D)


func _process_cursor():
	var ray_collider = $CursorRayCast.get_collider()
	if not ray_collider:
		return
	selected_object.emit(ray_collider)

	if Input.is_action_just_pressed("destroy"):
		var loader = get_tree().get_root().get_node("Root/World")
		loader.remove_block(ray_collider.position)
	if Input.is_action_just_pressed("place"):
		var loader = get_tree().get_root().get_node("Root/World")
		var pos = ray_collider.position + $CursorRayCast.get_collision_normal()
		loader.place_block("grass_block", pos.round())


func _physics_process(_delta):
	_process_cursor()
