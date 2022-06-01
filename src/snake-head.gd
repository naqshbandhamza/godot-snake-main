extends Area2D

var screensize
var pos
var prevpos
var vel = Vector2(32,0)
var extents



func _ready():
	screensize = get_viewport_rect().size
	pos = Vector2(0,0)
	prevpos = pos
	set_z_index(4)
	set_physics_process(true)
	
func _input(ev):
	if Input.is_key_pressed(KEY_RIGHT):
		vel.y=0
		vel.x=32
		$Sprite.texture = load('res://snake/snake-head-right-01.png')
	elif  Input.is_key_pressed(KEY_LEFT):
		vel.y=0
		vel.x=-32
		$Sprite.texture = load('res://snake/snake-head-left-01.png')
	elif  Input.is_key_pressed(KEY_UP):
		vel.x=0
		vel.y=-32
		$Sprite.texture = load('res://snake/snake-head-up-01.png')
	elif  Input.is_key_pressed(KEY_DOWN):
		vel.x=0
		vel.y=32
		$Sprite.texture = load('res://snake/snake-head-down-01.png')
	
		
func move_right(ex):
	vel.y=0
	vel.x=ex
	$Sprite.texture = load('res://snake/snake-head-right-01.png')
	
func move_left(ex):
	vel.y=0
	vel.x= -1 * ex
	$Sprite.texture = load('res://snake/snake-head-left-01.png')
	
func move_up(ex):
	vel.x=0
	vel.y= -1 * ex
	$Sprite.texture = load('res://snake/snake-head-up-01.png')
	
func move_down(ex):
	vel.x=0
	vel.y=ex
	$Sprite.texture = load('res://snake/snake-head-down-01.png')
	
func get_vel():
	return vel
	
func _physics_process(delta):
	pass
	


