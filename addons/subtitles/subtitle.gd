@tool
extends Resource
class_name Subtitle

enum Positions {
    BEHIND,
    OFF_SCEEN,
    OFF_SCREN_LEFT,
    LEFT,
    CENTER,
    RIGHT,
    OFF_SCREEN_RIGHT
}

enum Colors {
    WHITE,
    YELLOW,
    CYAN,
    GREEN
}

## The Text of the Subtitle.
@export var text:String = "":
    set(new_text):
        if new_text == null: text = ""
        else: text = new_text
## The Speaker Color. First Speaker is always white, second always yellow. Speakers should have consistent colors.
@export var speaker_color:Colors = Colors.WHITE:
    set(new_color):
        speaker_color = new_color
## Duration of the Subtitle. Choose 0 for continuous. Subtitles longer than 10 seconds are not reccomended.
@export_range(0,10) var duration:float:
    set(new_duration):
        duration = new_duration
## Position of the Speaker relative to the Screen.
@export var position:Positions = Positions.CENTER:
    set(new_position):
        position = new_position

func is_valid():
    return ( text != "" and text.split(" ").size() < 15 )
