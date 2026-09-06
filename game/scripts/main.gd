extends Node2D

var phase := "city"
var selected_starter := ""
var font: Font
@onready var player: CharacterBody2D = $Player
@onready var dialogue_box: PanelContainer = $DialogueBox
@onready var rival: Area2D = $Rival
@onready var battle: Control = $Battle

func _ready() -> void:
    font = ThemeDB.fallback_font
    dialogue_box.show_message("아르카디아 시티에 도착했다. 연구소로 가서 박사 에리안을 만나자.")
    battle.battle_finished.connect(_on_battle_finished)
    queue_redraw()

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("interact"):
        _interact()
    if phase == "starter":
        if Input.is_key_pressed(KEY_1): _choose_starter("나무지기")
        elif Input.is_key_pressed(KEY_2): _choose_starter("물짱이")
        elif Input.is_key_pressed(KEY_3): _choose_starter("불꽃숭이")
    elif phase == "complete" and Input.is_action_just_pressed("interact"):
        phase = "city"
        dialogue_box.show_message("여행을 시작하자. 판도르의 경계 너머에는 아직 밝혀지지 않은 생태계가 기다리고 있다.")
    queue_redraw()

func _interact() -> void:
    if player.global_position.distance_to(rival.global_position) < 90:
        dialogue_box.hide_message()
        battle.start_battle(selected_starter if selected_starter != "" else "파트너 포켓몬")
        return
    if player.global_position.x > 435 and player.global_position.x < 717 and player.global_position.y < 315:
        get_tree().change_scene_to_file("res://scenes/interiors/LabInterior.tscn")
        return
    if player.global_position.x > 85 and player.global_position.x < 280 and player.global_position.y > 420:
        get_tree().change_scene_to_file("res://scenes/interiors/CenterInterior.tscn")
        return
    if player.global_position.x > 865 and player.global_position.x < 1065 and player.global_position.y > 420:
        get_tree().change_scene_to_file("res://scenes/interiors/ShopInterior.tscn")
        return
    dialogue_box.show_message("아르카디아 시티의 에너지 간판이 깜빡인다. 어딘가에서 낮은 공명음이 들려온다.")

func _on_battle_finished(result: String) -> void:
    if result == "win":
        dialogue_box.show_message("라이벌: 이번에는 네가 이겼네... 하지만 다음에는 달라질 거야!")
    else:
        dialogue_box.show_message("라이벌: 괜찮아. 다시 도전하면 돼!")
    phase = "city"

func _choose_starter(starter: String) -> void:
    selected_starter = starter
    phase = "complete"
    dialogue_box.show_message("파트너로 %s를 선택했다. 황금 심장 파편이 금빛으로 빛난다.\n\n유물의 목소리: 하나로 만들지 마라. 서로 다른 채로 살아가게 하라.\n\n[E/Space] 계속" % starter)

func _draw() -> void:
    _draw_city_map()
    if phase == "starter":
        _draw_starter_menu()

func _draw_city_map() -> void:
    draw_rect(Rect2(0, 0, 1152, 648), Color("071321"))
    draw_rect(Rect2(28, 68, 1096, 510), Color("132c40"))
    # Skyline and distant towers
    for building in [Rect2(75, 105, 110, 90), Rect2(205, 92, 145, 103), Rect2(790, 100, 120, 95), Rect2(935, 83, 120, 112)]:
        draw_rect(building, Color("1d4357"))
        draw_line(building.position + Vector2(12, 20), building.position + Vector2(building.size.x - 12, 20), Color("3a7280"), 2)
        for wx in range(int(building.position.x + 18), int(building.end.x - 10), 28):
            draw_rect(Rect2(wx, building.position.y + 42, 10, 9), Color("78cad0"))
            draw_rect(Rect2(wx, building.position.y + 63, 10, 9), Color("467d8c"))
    draw_rect(Rect2(55, 82, 1042, 72), Color("1e4b63"))
    draw_string(font, Vector2(74, 116), "ARCADIA CITY  /  아르카디아 시티", HORIZONTAL_ALIGNMENT_LEFT, -1, 25, Color("c6f4ff"))
    draw_string(font, Vector2(75, 140), "판도르 지방 생명·에너지 연구 수도", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("87b8cd"))
    # Main plaza and roads
    draw_rect(Rect2(55, 180, 1042, 350), Color("1b5265"))
    draw_rect(Rect2(55, 300, 1042, 108), Color("253f4e"))
    draw_rect(Rect2(500, 180, 150, 350), Color("253f4e"))
    for x in range(75, 1080, 72):
        draw_line(Vector2(x, 351), Vector2(x + 34, 351), Color("b0b9a3"), 3)
    for y in range(205, 520, 58):
        draw_line(Vector2(565, y), Vector2(565, y + 28), Color("b0b9a3"), 3)
    # Green belts
    draw_rect(Rect2(75, 205, 285, 65), Color("28644f"))
    draw_rect(Rect2(785, 205, 280, 65), Color("28644f"))
    for x in range(100, 340, 48):
        _draw_tree(Vector2(x, 237))
    for x in range(810, 1050, 48):
        _draw_tree(Vector2(x, 237))
    # Research laboratory
    draw_rect(Rect2(405, 178, 342, 104), Color("347e8b"))
    draw_rect(Rect2(420, 190, 312, 75), Color("0e293b"))
    draw_rect(Rect2(436, 202, 280, 43), Color("173d50"))
    draw_string(font, Vector2(470, 229), "생명연구소", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("e8ffff"))
    draw_string(font, Vector2(508, 252), "LIFE RESEARCH LAB", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("76d5dc"))
    draw_circle(Vector2(576, 288), 28, Color("d7a84e"))
    draw_circle(Vector2(576, 288), 18, Color("ffe399"))
    draw_string(font, Vector2(520, 326), "연구소 광장", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("d8edf2"))
    # Shops and transit points
    _draw_shop(Rect2(95, 438, 175, 65), "포켓몬센터", Color("d96e7c"))
    _draw_shop(Rect2(875, 438, 175, 65), "아이템 상점", Color("d3a348"))
    draw_circle(Vector2(386, 472), 22, Color("4bb9c3"))
    draw_circle(Vector2(386, 472), 10, Color("d8fbff"))
    draw_string(font, Vector2(345, 515), "공중 교통", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("b5d8e1"))
    # Decorative lamps
    for x in [325, 825]:
        draw_line(Vector2(x, 292), Vector2(x, 335), Color("91b7bc"), 3)
        draw_circle(Vector2(x, 287), 9, Color("e5d17d"))
    draw_string(font, Vector2(70, 605), "WASD / 방향키: 이동    E / SPACE: 상호작용", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("9ab8ce"))

func _draw_tree(pos: Vector2) -> void:
    draw_rect(Rect2(pos + Vector2(-4, 8), Vector2(8, 20)), Color("77523c"))
    draw_circle(pos, 17, Color("4e9b68"))
    draw_circle(pos + Vector2(-10, 6), 11, Color("367956"))
    draw_circle(pos + Vector2(10, 7), 11, Color("65b878"))

func _draw_shop(rect: Rect2, label: String, accent: Color) -> void:
    draw_rect(rect, Color("163244"))
    draw_rect(Rect2(rect.position, Vector2(rect.size.x, 12)), accent)
    draw_rect(Rect2(rect.position + Vector2(20, 25), Vector2(rect.size.x - 40, 25)), Color("254d5c"))
    draw_string(font, rect.position + Vector2(38, 43), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("effaff"))

func _draw_starter_menu() -> void:
    draw_rect(Rect2(190, 170, 772, 300), Color(0.03, 0.06, 0.12, 0.97), true)
    draw_rect(Rect2(190, 170, 772, 300), Color("f1c96b"), false, 3)
    draw_string(font, Vector2(245, 220), "파트너 포켓몬을 선택하세요", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("fff0bd"))
    var names := ["1  나무지기", "2  물짱이", "3  불꽃숭이"]
    var colors := [Color("72bc82"), Color("65a9d9"), Color("e88455")]
    for i in range(3):
        var x: float = 245.0 + i * 220.0
        draw_circle(Vector2(x + 70, 315), 45, colors[i])
        draw_string(font, Vector2(x + 12, 400), names[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("ffffff"))
    draw_string(font, Vector2(245, 445), "숫자 1/2/3 키를 눌러 선택", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("a9c3d8"))

