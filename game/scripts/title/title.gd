extends Control

var font: Font
var pulse := 0.0
var hint := "ENTER 또는 SPACE를 눌러 시작"

func _ready() -> void:
    font = ThemeDB.fallback_font
    queue_redraw()

func _process(delta: float) -> void:
    pulse += delta
    if Input.is_action_just_pressed("ui_accept"):
        get_tree().change_scene_to_file("res://scenes/Main.tscn")
    queue_redraw()

func _draw() -> void:
    var size := get_viewport_rect().size
    draw_rect(Rect2(Vector2.ZERO, size), Color("07111f"))
    draw_circle(Vector2(size.x * 0.5, size.y * 0.38), 155.0 + sin(pulse) * 8.0, Color(0.12, 0.33, 0.47, 0.22))
    draw_circle(Vector2(size.x * 0.5, size.y * 0.38), 105.0, Color("d7a944"))
    draw_circle(Vector2(size.x * 0.5, size.y * 0.38), 78.0, Color("ffe28a"))
    draw_string(font, Vector2(size.x * 0.5 - 245, size.y * 0.20), "포켓몬스터 와일즈", HORIZONTAL_ALIGNMENT_LEFT, -1, 52, Color("f8e6a7"))
    draw_string(font, Vector2(size.x * 0.5 - 190, size.y * 0.28), "PANDOR PROTOTYPE", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("86cddd"))
    draw_string(font, Vector2(size.x * 0.5 - 145, size.y * 0.70), hint, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("ffffff"))
    draw_string(font, Vector2(size.x * 0.5 - 180, size.y * 0.86), "진정한 유대는 통제가 아니다", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("8baac0"))
