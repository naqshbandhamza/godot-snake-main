extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal fruitgot
onready var optext = get_node("Sprite2/optext")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_fruit_area_entered(area: Area2D) -> void:
	if area.get_name()=="snake-head":
		emit_signal("fruitgot",optext.text)
		
		#print(area.get_name()) # Replace with function body.
