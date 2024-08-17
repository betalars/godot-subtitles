@tool
extends Node
# I would really like to move this code into the main plugin script, but for some reason that does not work.

var _use_custom_font:String = "accessibility/closed_captions/use_custom_font"
var _text_scaling:String = "accessibility/closed_captions/text_scaling"
var _background_color:String = "accessibility/closed_captions/background_colour"
var project_settings_initialised:
	set(finished):
		if finished:
			project_settings_initialised = true
			_on_project_settings_update()

var captions_theme:Theme = preload("res://addons/closed_captions/captions.theme")

func _ready():
	ProjectSettings.settings_changed.connect(_on_project_settings_update)
	_on_project_settings_update()

func _on_project_settings_update():
	var font_name:StringName = ProjectSettings.get_setting(CaptionPlugin.use_custom_font_path)
		
		if captions_theme.default_font is SystemFont:
			# Making sure "Sans-Serif remains a failover"
			captions_theme.default_font.font_names.insert(0, font_name)
		else:
			push_warning("costum font configuration found, ignoring name set in Project Settings.")
		
	captions_theme.default_base_scale = ProjectSettings.get_setting(CaptionPlugin.text_scaling_path)
		var background: StyleBox = StyleBoxFlat.new()
	var bg_color: Color = ProjectSettings.get_setting(CaptionPlugin.background_color_path)
		if bg_color.a < 0.7:
			bg_color.a = 0.7
			push_warning("Transparency below 70% is not supported.")
		if bg_color.v > 0.6:
			bg_color.v = 0.6
		push_warning("Backgound Color must be WGCA complient. Setting was set too bright.")
		if bg_color.s > 0.7:
			bg_color.v = 0.6
		push_warning("High saturation of colour would cause some speaker names to blend into the background.")
	if !bg_color == ProjectSettings.get_setting(CaptionPlugin.background_color_path):
			push_warning("Background Color Settings have been adjusted.")
	background.bg_color = ProjectSettings.get_setting(CaptionPlugin.background_color_path)
		captions_theme.set_stylebox("normal", "RichTextLabel", background)
	
	
