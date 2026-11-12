class_name PlanetSkin
extends RefCounted
## One native theme, shared by every screen. World/character art is independent.
static var INK=Color("142333")
static var PANEL=Color("1d3040")
static var PAPER=Color("f2e5c7")
static var GOLD=Color("efcd89")
static var SAGE=Color("8fb9a5")
const BERRY=Color("a93f59")
const BUNDLED=preload("res://assets/fonts/DejaVuSans.ttf")
const BUNDLED_BOLD=preload("res://assets/fonts/DejaVuSans-Bold.ttf")
static var FONT: Font=BUNDLED
static var BOLD: Font=BUNDLED_BOLD
static var light=false
static var system_regular: SystemFont
static var system_bold: SystemFont

static func system_dark() -> bool:
	if OS.has_feature("web"):
		var appearance=JavaScriptBridge.get_interface("planetAppearance")
		if appearance!=null:return bool(appearance.systemDark())
	return DisplayServer.is_dark_mode() if DisplayServer.is_dark_mode_supported() else true

static func configure(prefs: Dictionary) -> void:
	light=prefs.get("theme","dark")=="light" or (prefs.get("theme")=="system" and not system_dark())
	INK=Color("eef3ea") if light else Color("142333")
	PANEL=Color("e0eade") if light else Color("1d3040")
	PAPER=Color("172d35") if light else Color("f2e5c7")
	GOLD=Color("67410b") if light else Color("efcd89")
	SAGE=Color("2d6255") if light else Color("8fb9a5")
	if prefs.get("font","system")=="system":
		if system_regular==null:
			system_regular=SystemFont.new();system_regular.font_names=PackedStringArray(["system-ui","Segoe UI","SF Pro Text","Noto Sans","DejaVu Sans","sans-serif"]);system_regular.fallbacks=[BUNDLED]
			system_bold=SystemFont.new();system_bold.font_names=system_regular.font_names;system_bold.font_weight=700;system_bold.fallbacks=[BUNDLED_BOLD]
		FONT=system_regular;BOLD=system_bold
	else:FONT=BUNDLED;BOLD=BUNDLED_BOLD

static func box(fill: Color,border: Color=Color("587780"),margin: int=14) -> StyleBoxFlat:
	var s=StyleBoxFlat.new();s.bg_color=fill;s.border_color=border;s.set_border_width_all(2);s.set_content_margin_all(margin)
	s.shadow_color=Color(0.025,0.06,0.1,0.3);s.shadow_size=5;s.shadow_offset=Vector2(0,4)
	return s
static func theme() -> Theme:
	var t=Theme.new();t.default_font=FONT;t.default_font_size=18
	for node in ["Label","Button","TooltipLabel"]:t.set_color("font_color",node,PAPER)
	for key in ["font_hover_color","font_focus_color"]:t.set_color(key,"Button",PAPER)
	t.set_color("font_disabled_color","Button",Color("52645f") if light else Color("acb8bc"))
	t.set_font("font","Button",BOLD)
	t.set_stylebox("panel","PanelContainer",box(PANEL))
	t.set_stylebox("normal","Button",box(Color("d2e1d3") if light else Color("294353"),Color("587780"),11))
	t.set_stylebox("hover","Button",box(Color("bfd4c4") if light else Color("345b66"),SAGE,11))
	t.set_stylebox("pressed","Button",box(Color("a9c5b4") if light else Color("182b3c"),GOLD,11))
	t.set_stylebox("disabled","Button",box(PANEL,Color("71857d"),11))
	var f=box(Color(0,0,0,0),GOLD,11);f.set_border_width_all(3);f.shadow_size=0;t.set_stylebox("focus","Button",f);t.set_stylebox("focus","HSlider",f)
	var slider=StyleBoxFlat.new();slider.bg_color=Color("5a727b");slider.content_margin_top=3;slider.content_margin_bottom=3;t.set_stylebox("slider","HSlider",slider)
	t.set_stylebox("panel","TooltipPanel",box(INK,GOLD,9))
	return t
static func primary(button: Button) -> void:
	button.add_theme_color_override("font_color",Color.WHITE)
	button.add_theme_color_override("font_hover_color",Color.WHITE)
	button.add_theme_color_override("font_focus_color",Color.WHITE)
	button.add_theme_stylebox_override("normal",box(BERRY,Color("d99093"),11))
	button.add_theme_stylebox_override("hover",box(Color("97405a"),GOLD,11))
	button.add_theme_stylebox_override("pressed",box(Color("733047"),GOLD,11))
