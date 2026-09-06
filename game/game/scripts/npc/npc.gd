extends Area2D

@export var npc_id := "rival"
@export var display_name := "라이벌"

func _ready() -> void:
    queue_redraw()

func _draw() -> void:
    draw_circle(Vector2.ZERO, 17, Color("b9d8ed"))
    draw_circle(Vector2(0, -10), 15, Color("557fc4"))
    draw_string(ThemeDB.fallback_font, Vector2(-34, 42), display_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("eaf6ff"))
