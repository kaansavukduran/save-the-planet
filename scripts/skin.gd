class_name PlanetSkin
extends RefCounted
## Project palette and native Godot UI skin. No new engine or UI dependency.
const INK=Color("142333")
const PANEL=Color("1d3040")
const PAPER=Color("f2e5c7")
const GOLD=Color("efcd89")
const SAGE=Color("8fb9a5")
const BERRY=Color("a93f59")
const FONT=preload("res://assets/fonts/DejaVuSans.ttf")
const BOLD=preload("res://assets/fonts/DejaVuSans-Bold.ttf")
static func box(fill: Color,border: Color=Color("587780"),margin: int=14) -> StyleBoxFlat:
	var s=StyleBoxFlat.new();s.bg_color=fill;s.border_color=border;s.set_border_width_all(2);s.set_content_margin_all(margin)
	s.shadow_color=Color(0.025,0.06,0.1,0.6);s.shadow_size=5;s.shadow_offset=Vector2(0,4)
	return s
static func theme() -> Theme:
	var t=Theme.new();t.default_font=FONT;t.default_font_size=17
	t.set_color("font_color","Label",PAPER)
	t.set_color("font_color","Button",PAPER);t.set_color("font_hover_color","Button",Color.WHITE);t.set_color("font_focus_color","Button",Color.WHITE)
	t.set_color("font_disabled_color","Button",Color("84949b"))
	t.set_font("font","Button",BOLD)
	t.set_stylebox("panel","PanelContainer",box(PANEL))
	t.set_stylebox("normal","Button",box(Color("294353"),Color("587780"),11))
	t.set_stylebox("hover","Button",box(Color("345b66"),SAGE,11))
	t.set_stylebox("pressed","Button",box(Color("182b3c"),GOLD,11))
	t.set_stylebox("disabled","Button",box(Color("233441"),Color("3f5660"),11))
	var f=box(Color(0,0,0,0),GOLD,11);f.set_border_width_all(3);f.shadow_size=0;t.set_stylebox("focus","Button",f)
	var slider=StyleBoxFlat.new();slider.bg_color=Color("5a727b");slider.content_margin_top=3;slider.content_margin_bottom=3;t.set_stylebox("slider","HSlider",slider)
	t.set_color("font_color","TooltipLabel",PAPER);t.set_stylebox("panel","TooltipPanel",box(INK,GOLD,9))
	return t
static func primary(button: Button) -> void:
	button.add_theme_stylebox_override("normal",box(BERRY,Color("d99093"),11))
	button.add_theme_stylebox_override("hover",box(Color("b9546b"),GOLD,11))
	button.add_theme_stylebox_override("pressed",box(Color("8b3c56"),GOLD,11))
