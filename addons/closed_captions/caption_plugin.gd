@tool
extends EditorPlugin
class_name CaptionPlugin

# Cosmetic: declaring values of property names as variables to improve readability
const allow_sound_stacking_path:String = "accessibility/closed_captions/allow_sound_stacking"
const use_custom_font_path:String = "accessibility/closed_captions/use_custom_font"
const target_display_type_path:String = "accessibility/closed_captions/target_display_type"
const text_scaling_path:String = "accessibility/closed_captions/text_scaling"
const background_color_path:String = "accessibility/closed_captions/background_colour"
const audibility_threshhold_path: String = "accessibility/closed_captions/sensitivity_threashold"
const display_continuous_sounds_path: String = "accessibility/closed_captions/display_continous_sounds"
const update_sound_directions_path: String = "accessibility/closed_captions/update_sound_directions"

func _enable_plugin():
	_initialise_project_settings()
	
func _enter_tree():
	_initialise_project_settings()
	add_autoload_singleton("CaptionServer", "res://addons/closed_captions/caption_server.gd")
	add_autoload_singleton("CaptionTheme", "res://addons/closed_captions/caption_theme.gd")
	add_custom_type("Caption", "Resource", preload("res://addons/closed_captions/caption.gd"), preload("icons/Caption.svg"))
	add_custom_type("CaptionedAudioStream", "Resource", preload("res://addons/closed_captions/captioned_audio_stream.gd"), preload("icons/CaptionedAudioStream.svg"))
	add_custom_type("MultiCaptionAudioStream", "CaptionedAudioStream", preload("res://addons/closed_captions/multi_caption_audio_stream.gd"), preload("icons/MultiCaptionAudioStream.svg"))
	add_custom_type("CaptionedAudioStreamPlayer", "AudioStreamPlayer", preload("res://addons/closed_captions/captioned_autio_stream_player.gd"), preload("icons/CaptionedAudioStreamPlayer.svg"))
	add_custom_type("CaptionLabel", "RichTextLabel", preload("res://addons/closed_captions/caption_label.gd"), preload("icons/CaptionLabel.svg"))
	add_custom_type("CaptionDisplay", "VBoxContainer", preload("res://addons/closed_captions/caption_display.gd"), preload("icons/CaptionDisplay.svg"))

func _exit_tree():
	remove_custom_type("Caption")
	remove_custom_type("CaptionedAudioStream")
	remove_custom_type("MultiCaptionAudioStream")
	remove_custom_type("CaptionedAudioStreamPlayer")
	remove_custom_type("CaptionLabel")
	remove_custom_type("CaptionDisplay")
	remove_autoload_singleton("CaptionServer")
	remove_autoload_singleton("CaptionTheme")

func _initialise_project_settings():
	if !ProjectSettings.has_setting(allow_sound_stacking_path):
		ProjectSettings.set_setting(allow_sound_stacking_path, false)
		ProjectSettings.add_property_info({
			"name": allow_sound_stacking_path,
			"type": TYPE_BOOL,
			"hint": PROPERTY_HINT_NONE,
			# At the moment, this will not be rendered by godot editor, see https://github.com/godotengine/godot-proposals/discussions/8224
			"doc": "Disable to make sure only one sound is captioned at a time."
		})
		ProjectSettings.set_initial_value(allow_sound_stacking_path, false)
	
	if !ProjectSettings.has_setting(use_custom_font_path):
		ProjectSettings.set_setting(use_custom_font_path, "")
		ProjectSettings.add_property_info({
			"name": use_custom_font_path,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_NONE,
			"doc": "Set the name of a custom font. Needs to be installed on user device. Alternatively, you can set the font directly by modifying captions.theme."
		})
		ProjectSettings.set_initial_value(use_custom_font_path, "")
	
	if !ProjectSettings.has_setting(target_display_type_path):
		ProjectSettings.set_setting(target_display_type_path, 0)
		ProjectSettings.add_property_info({
			"name": target_display_type_path,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "detect,Desktop,Constole,mobile,BBC"
		})
		ProjectSettings.set_initial_value(target_display_type_path, 0)
	
	if !ProjectSettings.has_setting(text_scaling_path):
		ProjectSettings.set_setting(text_scaling_path, 1)
		ProjectSettings.add_property_info({
			"name": text_scaling_path,
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0.5,5,0.1",
			"doc": "Define custom scaling."
		})
		ProjectSettings.set_initial_value(text_scaling_path, 1)
	
	if !ProjectSettings.has_setting(background_color_path):
		ProjectSettings.set_setting(background_color_path, Color.BLACK)
		ProjectSettings.add_property_info({
			"name": background_color_path,
			"type": TYPE_COLOR,
			"hint": PROPERTY_HINT_NONE,
		"description": "Sets the Background color of Caption Boxes. Will ignore non-WGCA complient settings."
		})
		ProjectSettings.set_initial_value(background_color_path, Color.BLACK)
	
	if !ProjectSettings.has_setting(audibility_threshhold_path):
		ProjectSettings.set_setting(audibility_threshhold_path, 1)
		ProjectSettings.add_property_info({
			"name": audibility_threshhold_path,
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0.1,5,0.1",
			"doc": "Define custom scaling."
		})
		ProjectSettings.set_initial_value(audibility_threshhold_path, 1)
	
	if !ProjectSettings.has_setting(display_continuous_sounds_path):
		ProjectSettings.set_setting(display_continuous_sounds_path, 1)
		ProjectSettings.add_property_info({
			"name": display_continuous_sounds_path,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "once, when_becoming_audible, always"
		})
		ProjectSettings.set_initial_value(display_continuous_sounds_path, 1)
	
	if !ProjectSettings.has_setting(update_sound_directions_path):
		ProjectSettings.set_setting(update_sound_directions_path, 1)
		ProjectSettings.add_property_info({
			"name": update_sound_directions_path,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "never, at_intervals, always"
		})
		ProjectSettings.set_initial_value(update_sound_directions_path, 1)
		
	var error: int = ProjectSettings.save()
	if error: push_error("Encountered error %d when saving project settings." % error)
