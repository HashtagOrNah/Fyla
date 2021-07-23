extends Spatial

export var text : String = "R"

func _ready():
	
	$Viewport/RichTextLabel.text = text
