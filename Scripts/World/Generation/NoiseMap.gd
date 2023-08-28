class_name NoiseMap


var _map: Image
var _center: Vector2i
var _noise = FastNoiseLite.new()
var _size_step: int = 16 * 3


func _init(noise_seed: int):
	_center = Vector2i(_size_step, _size_step)
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.seed = noise_seed

	var size = Vector2i(_size_step * 2, _size_step * 2)
	_map = Image.create(size.x, size.y, false, Image.FORMAT_L8)
	_generate(Vector2i(), size)


func _generate(from: Vector2i, to: Vector2i):
	for x in range(min(from.x, to.x), max(from.x, to.x)):
		for y in range(min(from.y, to.y), max(from.y, to.y)):
			var value = _noise.get_noise_2d(x - _center.x, y - _center.y)
			_map.set_pixel(x, y, Color((value + 1) / 2, 0, 0))


func get_noise_at(pos: Vector2i) -> float:
	pos += _center
	return _map.get_pixel(pos.x, pos.y).v
