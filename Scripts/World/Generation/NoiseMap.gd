class_name NoiseMap


var _map: Image
var _center: Vector2i
var _noise = FastNoiseLite.new()


func _init(noise_seed: int):
	_center = Vector2i(Chunks.size * 3, Chunks.size * 3)
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.seed = noise_seed

	var size = _center * 2
	_map = _create_map(size)


func _create_map(size: Vector2i) -> Image:
	return Image.create(size.x, size.y, false, Image.FORMAT_L8)


func _get_bounds() -> Rect2i:
	var size = _map.get_size() / Chunks.size
	return Rect2i(-_center / Chunks.size, size)


func _get_padded_chunk(chunk: Vector2i) -> Vector2i:
	if chunk.x >= 0:
		chunk.x += 1
	if chunk.y >= 0:
		chunk.y += 1
	return chunk


func _resize_to_fit(chunk: Vector2i):
	var bounds = _get_bounds()
	var new_bounds = bounds.expand(chunk)
	var origin_diff = new_bounds.position - bounds.position
	var current_map = _map
	var curr_rect = Rect2i(Vector2i(), _map.get_size())
	_map = _create_map(new_bounds.size * Chunks.size)
	_center -= origin_diff * Chunks.size
	_map.blit_rect(current_map, curr_rect, origin_diff * Chunks.size)


func generate_chunk(chunk: Vector2i):
	var padded_chunk = _get_padded_chunk(chunk)
	if not Utils.rect_contains(_get_bounds(), padded_chunk):
		_resize_to_fit(padded_chunk)
	for x in range(Chunks.size):
		for y in range(Chunks.size):
			var world_pos = Vector2i(x, y) + chunk * Chunks.size
			var pos = world_pos + _center
			var value = _noise.get_noise_2d(world_pos.x, world_pos.y)
			_map.set_pixel(pos.x, pos.y, Color((value + 1) / 2, 0, 0))


func get_noise_at(pos: Vector2i) -> float:
	pos += _center
	assert(pos <= _map.get_size(), "Invalid noise position")
	return _map.get_pixel(pos.x, pos.y).v
