class_name ContextMenuItem
extends Node

var id: String;
var function: Callable;
var disabled: bool;
var idx: int = -1;

func _init(i: String, f: Callable, enabled: bool = false):
	id = i;
	function = f;
	disabled = !enabled;
