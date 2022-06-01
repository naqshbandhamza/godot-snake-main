extends Area2D


var screensize
var pos
var vel = Vector2(0,0)


func _ready():
	randomize()
	screensize = get_viewport_rect().size
	pos = Vector2(0,0)
	set_z_index(3)
	set_physics_process(true)
	
func move_right(ex):
	vel.y=0
	vel.x=ex
	pos+=vel
	
func move_left(ex):
	vel.y=0
	vel.x= -1 * ex
	pos+=vel
	
func move_up(ex):
	vel.x=0
	vel.y= -1 * ex
	pos+=vel
	
func move_down(ex):
	vel.x=0
	vel.y=ex
	pos+=vel
	
func _physics_process(delta):
	position = pos
	


signal headoverlap

func _on_snakebody_area_entered(area: Area2D) -> void:
	if area.get_name()=='snake-head':
		emit_signal("headoverlap")
