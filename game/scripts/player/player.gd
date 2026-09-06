extends CharacterBody2D

@export var speed := 230.0
var facing := Vector2.DOWN
var font: Font

func _ready() -> void:
    font = ThemeDB.fallback_font
    queue_redraw()

func _physics_process(_delta: float) -> void:
    var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = direction * speed
    if direction.length() > 0:
        facing = direction.normalized()
    move_and_slide()
    queue_redraw()

func _draw() -> void:
    draw_circle(Vector2(0, 2), 17, Color("f4d7bd"))
    draw_circle(Vector2(0, -9), 15, Color("e77c55"))
    draw_line(Vector2.ZERO, facing * 24.0, Color("fff1bf"), 3)
