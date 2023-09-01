class_name Utils


static func mod(x: int, y: int) -> int:
    return (x % y + y) % y


static func rect_contains(rect: Rect2i, point: Vector2i) -> bool:
    return point >= rect.position and point <= rect.position + rect.size
