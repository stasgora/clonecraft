class_name NoiseMap


var _map: Image
var _center: Vector2i
var _noise = FastNoiseLite.new()
var _chunk_size: int = 16


func _init(noise_seed: int):
	_center = Vector2i(_chunk_size * 3, _chunk_size * 3)
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.seed = noise_seed

	var size = _center * 2
	_map = Image.create(size.x, size.y, false, Image.FORMAT_L8)


func generate_chunk(chunk: Vector2i):
	for x in range(_chunk_size):
		for y in range(_chunk_size):
			var world_pos = Vector2i(x, y) + chunk * _chunk_size
			var pos = world_pos + _center
			var value = _noise.get_noise_2d(world_pos.x, world_pos.y)
			_map.set_pixel(pos.x, pos.y, Color((value + 1) / 2, 0, 0))


func get_noise_at(pos: Vector2i) -> float:
	pos += _center
	return _map.get_pixel(pos.x, pos.y).v
