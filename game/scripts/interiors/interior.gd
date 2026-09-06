extends Node2D

@export_enum("lab", "center", "shop") var interior_type := "lab"
var font: Font
var message := "E: 상호작용    ESC: 도시로 돌아가기"
var starter_mode := false

func _ready() -> void:
    font = ThemeDB.fallback_font
    queue_redraw()

func _process(_delta: float) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().change_scene_to_file("res://scenes/Main.tscn")
    if Input.is_action_just_pressed("interact"):
        _interact()
    if starter_mode:
        if Input.is_key_pressed(KEY_1): _choose_starter("나무지기")
        elif Input.is_key_pressed(KEY_2): _choose_starter("물짱이")
        elif Input.is_key_pressed(KEY_3): _choose_starter("불꽃숭이")
    queue_redraw()

func _interact() -> void:
    if interior_type == "lab":
        starter_mode = true
        message = "박사 에리안: 파트너를 선택하렴. 1 나무지기 / 2 물짱이 / 3 불꽃숭이"
    elif interior_type == "center":
        message = "간호 담당자: 포켓몬의 상태를 회복했어. 모두 건강해!"
    else:
        message = "상점 직원: 필요한 도구를 둘러보렴. 현재는 테스트용 상점이야."

func _choose_starter(starter: String) -> void:
    starter_mode = false
    message = "%s가 네 파트너가 되었다! 황금 심장 파편이 조용히 공명한다." % starter

func _draw() -> void:
    var title := ""
    if interior_type == "lab": title = "생명연구소 내부"
    elif interior_type == "center": title = "포켓몬센터 내부"
    else: title = "아이템 상점 내부"
    draw_rect(Rect2(0, 0, 1152, 648), Color("08131f"))
    draw_rect(Rect2(55, 55, 1042, 510), Color("d7c49b"))
    draw_rect(Rect2(75, 75, 1002, 470), Color("5b8290"))
    draw_rect(Rect2(75, 390, 1002, 155), Color("315568"))
    draw_rect(Rect2(75, 75, 1002, 18), Color("f0d482"))
    draw_string(font, Vector2(90, 125), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("fff0bd"))
    if interior_type == "lab": _draw_lab()
    elif interior_type == "center": _draw_center()
    else: _draw_shop()
    draw_rect(Rect2(75, 470, 1002, 75), Color(0.02, 0.05, 0.09, 0.92))
    draw_string(font, Vector2(98, 500), message, HORIZONTAL_ALIGNMENT_LEFT, 940, 18, Color("f1f7fb"))
    draw_string(font, Vector2(98, 528), "E / SPACE: 상호작용     1/2/3: 파트너 선택(연구소)     ESC: 도시로 돌아가기", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("a9c6d4"))

func _draw_lab() -> void:
    draw_rect(Rect2(135, 170, 280, 145), Color("25475b"))
    draw_rect(Rect2(155, 190, 240, 100), Color("172d40"))
    draw_string(font, Vector2(185, 245), "생명 에너지 분석실", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("bcebf0"))
    draw_circle(Vector2(590, 245), 65, Color("d6ad55"))
    draw_circle(Vector2(590, 245), 46, Color("ffe9a0"))
    draw_circle(Vector2(590, 245), 20, Color("fff7d0"))
    draw_string(font, Vector2(510, 345), "황금 심장 파편", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("fff0b4"))
    draw_rect(Rect2(780, 175, 180, 140), Color("203e53"))
    for y in range(200, 290, 30):
        draw_line(Vector2(805, y), Vector2(935, y), Color("71c4c8"), 4)

func _draw_center() -> void:
    draw_rect(Rect2(180, 170, 790, 120), Color("e8e1cc"))
    draw_circle(Vector2(575, 205), 45, Color("e87587"))
    draw_circle(Vector2(575, 205), 25, Color("fff4e8"))
    draw_string(font, Vector2(430, 270), "회복 터미널", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("385768"))
    for x in [260, 430, 720, 865]:
        draw_rect(Rect2(x, 330, 120, 55), Color("e2d6b9"))
        draw_circle(Vector2(x + 60, 345), 9, Color("80cbd0"))
        draw_string(font, Vector2(x + 30, 375), "대기석", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("526e78"))

func _draw_shop() -> void:
    draw_rect(Rect2(140, 165, 250, 175), Color("8b6b43"))
    draw_rect(Rect2(170, 195, 190, 110), Color("284858"))
    draw_string(font, Vector2(200, 250), "ITEM MART", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("ffe69a"))
    var colors := [Color("e57c7c"), Color("7ac4d1"), Color("ddb553"), Color("9e82d5")]
    for i in range(4):
        var x: float = 520.0 + i * 115.0
        draw_rect(Rect2(x, 190, 75, 120), Color("d7c09a"))
        draw_circle(Vector2(x + 37, 235), 22, colors[i])
        draw_string(font, Vector2(x + 12, 285), "도구 %d" % (i + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("fff9e8"))
