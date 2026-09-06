extends PanelContainer

@onready var text_label: Label = $Text

func _ready() -> void:
    visible = false

func show_message(message: String) -> void:
    text_label.text = message
    visible = true

func hide_message() -> void:
    visible = false
