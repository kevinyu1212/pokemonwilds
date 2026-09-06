extends Control

signal battle_finished(result: String)

var font: Font
var player_hp := 32
var rival_hp := 28
var message := "라이벌이 포켓몬을 내보냈다!"
var player_name := "파트너 포켓몬"
var buttons: Array[Button] = []

func _ready() -> void:
    font = ThemeDB.fallback_font
    visible = false
    _build_buttons()
    queue_redraw()

func start_battle(starter: String = "파트너 포켓몬") -> void:
    player_name = starter
    player_hp = 32
    rival_hp = 28
    message = "라이벌: 첫 배틀이야! 내 포켓몬의 힘을 보여주겠어!"
    visible = true
    _set_buttons_enabled(true)
    queue_redraw()

func _build_buttons() -> void:
    var labels := ["잎날가르기", "물대포", "불꽃세례", "포켓몬"]
    for i in range(labels.size()):
        var button := Button.new()
        button.text = labels[i]
        button.position = Vector2(620 + (i % 2) * 205, 495 + (i / 2) * 50)
        button.size = Vector2(185, 40)
        button.add_theme_font_size_override("font_size", 18)
        button.pressed.connect(_on_move_pressed.bind(i))
        add_child(button)
        buttons.append(button)

func _set_buttons_enabled(enabled: bool) -> void:
    for button in buttons:
        button.disabled = not enabled

func _on_move_pressed(move_index: int) -> void:
    if not visible: return
    var moves := ["잎날가르기", "물대포", "불꽃세례", "포켓몬"]
    if move_index == 3:
        message = "지금은 포켓몬을 교체할 수 없다!"
        queue_redraw()
        return
    var damage: int = [8, 9, 10][move_index]
    rival_hp = max(0, rival_hp - damage)
    if rival_hp <= 0:
        message = "효과가 굉장했다! 라이벌의 포켓몬이 쓰러졌다!"
        _set_buttons_enabled(false)
        queue_redraw()
        await get_tree().create_timer(1.0).timeout
        visible = false
        battle_finished.emit("win")
        return
    message = "%s 사용! 라이벌의 포켓몬에게 %d의 데미지!" % [moves[move_index], damage]
    queue_redraw()
    await get_tree().create_timer(0.7).timeout
    var enemy_damage: int = 5
    player_hp = max(0, player_hp - enemy_damage)
    if player_hp <= 0:
        message = "파트너 포켓몬이 쓰러졌다..."
        _set_buttons_enabled(false)
        queue_redraw()
        await get_tree().create_timer(1.0).timeout
        visible = false
        battle_finished.emit("lose")
    else:
        message = "라이벌의 포켓몬 공격! 파트너가 %d의 데미지를 받았다." % enemy_damage
        queue_redraw()

func _draw() -> void:
    if not visible: return
    var size := get_viewport_rect().size
    draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.04, 0.08, 0.96))
    draw_rect(Rect2(55, 55, size.x - 110, 530), Color("264b5a"))
    draw_string(font, Vector2(90, 105), "라이벌 배틀", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("ffe49b"))
    draw_string(font, Vector2(780, 135), "라이벌의 포켓몬", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("eaf6ff"))
    draw_string(font, Vector2(125, 400), player_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("eaf6ff"))
    draw_circle(Vector2(830, 270), 70, Color("557fc4"))
    draw_circle(Vector2(300, 270), 70, Color("e58b58"))
    _draw_hp(Vector2(780, 155), rival_hp, 28, Color("ef7462"))
    _draw_hp(Vector2(125, 420), player_hp, 32, Color("78d18a"))
    draw_rect(Rect2(75, 475, 500, 90), Color("102333"))
    draw_rect(Rect2(75, 475, 500, 90), Color("a4d5dc"), false, 2)
    draw_string(font, Vector2(100, 512), message, HORIZONTAL_ALIGNMENT_LEFT, 450, 17, Color("ffffff"))
    draw_string(font, Vector2(620, 455), "기술을 선택하세요", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("c8e8f0"))

func _draw_hp(position: Vector2, hp: int, max_hp: int, color: Color) -> void:
    draw_rect(Rect2(position, Vector2(250, 18)), Color("17232b"))
    draw_rect(Rect2(position, Vector2(250.0 * float(hp) / max_hp, 18)), color)
    draw_string(font, position + Vector2(260, 16), "%d/%d" % [hp, max_hp], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("ffffff"))
