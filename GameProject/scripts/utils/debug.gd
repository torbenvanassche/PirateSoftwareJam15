extends Node

var show_log: bool = true;

func message(s: String):
	if show_log:
		print(s);
		
func warn(s: String):
	if show_log:
		push_warning(s);
		
func err(s: String):
	if show_log:
		printerr(s);
