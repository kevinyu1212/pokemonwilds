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
    if player.global_position.x > 435 and player.global_position.x < 717 and player.global_position.y < 285:
        phase = "starter"
        dialogue_box.show_message("박사 에리안: 황금 심장 파편이 네게 반응하고 있어. 1/2/3으로 파트너를 선택하렴.")
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
    draw_rect(Rect2(0, 0, 1152, 648), Color("091426"))
    draw_rect(Rect2(35, 80, 1082, 490), Color("152b42"))
    draw_rect(Rect2(55, 95, 1042, 75), Color("213e5c"))
    draw_string(font, Vector2(70, 130), "ARCADIA CITY  /  아르카디아 시티", HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("bde9ff"))
    draw_string(font, Vector2(70, 157), "판도르 지방 생명·에너지 연구 수도", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("81a9c9"))
    draw_rect(Rect2(90, 205, 972, 310), Color("1d4560"))
    for x in range(115, 1060, 95): draw_line(Vector2(x, 205), Vector2(x, 515), Color("295d76"), 2)
    for y in range(230, 516, 70): draw_line(Vector2(90, y), Vector2(1062, y), Color("295d76"), 2)
    draw_rect(Rect2(435, 115, 282, 155), Color("346c83"))
    draw_rect(Rect2(458, 140, 236, 90), Color("0e263c"))
    draw_string(font, Vector2(483, 192), "생명연구소", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("e7fbff"))
    draw_string(font, Vector2(487, 218), "LIFE RESEARCH LAB", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("80d6dc"))
    draw_circle(Vector2(576, 335), 38, Color("e2b95d"))
    draw_circle(Vector2(576, 335), 25, Color("ffd982"))
    draw_string(font, Vector2(532, 400), "중앙 광장", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("c2d8e7"))
    draw_string(font, Vector2(70, 600), "WASD / 방향키: 이동    E / SPACE: 상호작용", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("9ab8ce"))
    if phase == "starter":
        draw_rect(Rect2(190, 170, 772, 300), Color(0.03, 0.06, 0.12, 0.96), true)
        draw_rect(Rect2(190, 170, 772, 300), Color("f1c96b"), false, 3)
        draw_string(font, Vector2(245, 220), "파트너 포켓몬을 선택하세요", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("fff0bd"))
        var names := ["1  나무지기", "2  물짱이", "3  불꽃숭이"]
        var colors := [Color("72bc82"), Color("65a9d9"), Color("e88455")]
        for i in range(3):
            var x := 245.0 + i * 220.0
            draw_circle(Vector2(x + 70, 315), 45, colors[i])
            draw_string(font, Vector2(x + 12, 400), names[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("ffffff"))
