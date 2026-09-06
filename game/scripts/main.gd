extends Node2D

const PLAYER_SPEED := 230.0
var player_position := Vector2(576, 420)
var dialogue := "아르카디아 시티에 도착했다. 연구소로 가서 박사 에리안을 만나자."
var dialogue_visible := true
var dialogue_timer := 0.0
var phase := "city"
var selected_starter := ""
var player_facing := Vector2.DOWN
var font: Font

func _ready() -> void:
    font = ThemeDB.fallback_font
    queue_redraw()

func _process(delta: float) -> void:
    var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if phase == "city":
        if direction.length() > 0:
            player_facing = direction.normalized()
            player_position += direction * PLAYER_SPEED * delta
            player_position.x = clamp(player_position.x, 45.0, 1107.0)
            player_position.y = clamp(player_position.y, 85.0, 555.0)
        if Input.is_action_just_pressed("interact"):
            _interact()
    elif phase == "starter":
        for i in range(3):
            if Input.is_key_pressed(KEY_1 + i):
                _choose_starter(i)
    elif phase == "complete" and Input.is_action_just_pressed("interact"):
        phase = "city"
        dialogue = "여행을 시작하자. 판도르의 경계 너머에는 아직 밝혀지지 않은 생태계가 기다리고 있다."
        dialogue_visible = true
    queue_redraw()

func _interact() -> void:
    var lab := Rect2(435, 115, 282, 155)
    if lab.has_point(player_position):
        phase = "starter"
        dialogue = "박사 에리안: 황금 심장 파편이 네게 반응하고 있어. 먼저 파트너를 선택하렴."
        dialogue_visible = true
    elif player_position.distance_to(Vector2(576, 335)) < 95:
        dialogue = "라이벌: 강해지는 것이 포켓몬을 위한 가장 확실한 방법이야. 먼저 앞서가겠어!"
        dialogue_visible = true
    else:
        dialogue = "아르카디아 시티의 에너지 간판이 깜빡인다. 어딘가에서 낮은 공명음이 들려온다."
        dialogue_visible = true

func _choose_starter(index: int) -> void:
    var starters := ["나무지기", "물짱이", "불꽃숭이"]
    selected_starter = starters[index]
    phase = "complete"
    dialogue = "파트너로 %s를 선택했다. 황금 심장 파편이 금빛으로 빛난다.\n\n유물의 목소리: 하나로 만들지 마라. 서로 다른 채로 살아가게 하라.\n\n[스페이스/E] 계속" % selected_starter
    dialogue_visible = true

func _draw() -> void:
    _draw_city()
    _draw_player()
    if phase == "starter":
        _draw_starter_menu()
    if dialogue_visible:
        _draw_dialogue()

func _draw_city() -> void:
    draw_rect(Rect2(0, 0, 1152, 648), Color("091426"))
    draw_rect(Rect2(35, 80, 1082, 490), Color("152b42"))
    draw_rect(Rect2(55, 95, 1042, 75), Color("213e5c"))
    draw_string(font, Vector2(70, 130), "ARCADIA CITY  /  아르카디아 시티", HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("bde9ff"))
    draw_string(font, Vector2(70, 157), "판도르 지방 생명·에너지 연구 수도", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("81a9c9"))
    draw_rect(Rect2(90, 205, 972, 310), Color("1d4560"))
    for x in range(115, 1060, 95):
        draw_line(Vector2(x, 205), Vector2(x, 515), Color("295d76"), 2)
    for y in range(230, 516, 70):
        draw_line(Vector2(90, y), Vector2(1062, y), Color("295d76"), 2)
    draw_rect(Rect2(435, 115, 282, 155), Color("346c83"))
    draw_rect(Rect2(458, 140, 236, 90), Color("0e263c"))
    draw_string(font, Vector2(483, 192), "생명연구소", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("e7fbff"))
    draw_string(font, Vector2(487, 218), "LIFE RESEARCH LAB", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("80d6dc"))
    draw_circle(Vector2(576, 335), 38, Color("e2b95d"))
    draw_circle(Vector2(576, 335), 25, Color("ffd982"))
    draw_string(font, Vector2(532, 400), "중앙 광장", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("c2d8e7"))
    draw_string(font, Vector2(70, 600), "WASD / 방향키: 이동    E / SPACE: 상호작용", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("9ab8ce"))

func _draw_player() -> void:
    draw_circle(player_position, 18, Color("f4d7bd"))
    draw_circle(player_position + Vector2(0, -10), 15, Color("e77c55"))
    draw_line(player_position, player_position + player_facing * 25, Color("fff1bf"), 3)

func _draw_dialogue() -> void:
    draw_rect(Rect2(55, 530, 1042, 92), Color(0.02, 0.04, 0.08, 0.95), true)
    draw_rect(Rect2(55, 530, 1042, 92), Color("82c9dc"), false, 2)
    var lines := dialogue.split("\\n")
    for i in range(lines.size()):
        draw_string(font, Vector2(78, 560 + i * 22), lines[i], HORIZONTAL_ALIGNMENT_LEFT, 980, 18, Color("f2f7fb"))

func _draw_starter_menu() -> void:
    draw_rect(Rect2(190, 170, 772, 300), Color(0.03, 0.06, 0.12, 0.96), true)
    draw_rect(Rect2(190, 170, 772, 300), Color("f1c96b"), false, 3)
    draw_string(font, Vector2(245, 220), "파트너 포켓몬을 선택하세요", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("fff0bd"))
    var names := ["1  나무지기", "2  물짱이", "3  불꽃숭이"]
    var colors := [Color("72bc82"), Color("65a9d9"), Color("e88455")]
    for i in range(3):
        var x := 245.0 + i * 220.0
        draw_circle(Vector2(x + 70, 315), 45, colors[i])
        draw_string(font, Vector2(x + 12, 400), names[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("ffffff"))
    draw_string(font, Vector2(245, 445), "숫자 1/2/3 키를 눌러 선택", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("a9c3d8"))
