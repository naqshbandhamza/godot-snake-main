extends Area2D


var screensize
var pos
var vel = Vector2(0,0)

onready var endtail = get_node("Sprite")


func _ready():
	randomize()
	screensize = get_viewport_rect().size
	pos = Vector2(0,0)
	set_z_index(2)
	set_physics_process(true)
	
func move_right(ex):
	vel.y=0
	vel.x=ex
	pos+=vel
	endtail.rotation_degrees = 0
	
func move_left(ex):
	vel.y=0
	vel.x= -1 * ex
	pos+=vel
	endtail.rotation_degrees = 0
func move_up(ex):
	vel.x=0
	vel.y= -1 * ex
	pos+=vel
	endtail.rotation_degrees = 90
func move_down(ex):
	vel.x=0
	vel.y=ex
	pos+=vel
	endtail.rotation_degrees = 90
func _physics_process(delta):
	position = pos
	

signal taileatlast


func _on_tail2_area_entered(area: Area2D) -> void:
	if area.get_name()=="snake-head":
		emit_signal("taileatlast")
