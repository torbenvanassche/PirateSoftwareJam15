extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	Manager.instance.wisp_counter = self;
	visible = false;

func _value_changed(new_value):
	if new_value == max_value:
		$Label.text = "Good job!"
