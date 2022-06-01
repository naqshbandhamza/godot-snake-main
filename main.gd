extends Node

onready var sprite = preload("res://src/snake-head.tscn")
onready var sprite2 = preload("res://src/snake-body.tscn")
onready var sprite3 = preload("res://src/tail1.tscn")
onready var sprite4 = preload("res://src/tail2.tscn")
onready var gamecontrols = preload("res://src/components/controls.tscn")
onready var Choices = preload("res://src/components/Choices.tscn")
onready var Question = preload("res://src/components/Questions.tscn")
onready var Progress = preload("res://src/components/TextureProgressBar.tscn")
onready var ScoreNode = preload("res://src/components/Score.tscn")
onready var Live = preload("res://src/components/Lives.tscn")
onready var reload = false
onready var gframe = get_node("Border-box/ReferenceRect")
onready var timerr = get_node("timer/Timer")
#onready var infobox = get_node("infobox")
onready var gframesize = gframe.get_rect().size
onready var goverfor = preload("res://src/components/gameover.tscn")
onready var menuover = preload("res://src/components/menu.tscn")
onready var pathj = "user://data.data"
#onready var pauseyescontroller = get_node("pausecontroller")
const file_name = "save.data"
var textj
var ttextjj
var dataj = {}
var answerdata
var gameflag = false
var jflag
var gcontrols
var gchoices
var gquestion
var gprogress
var gscore
var glives


var default_json_data = {
"questions": [
{
"question": "1 + 1 = _____",
"options": [
{ "value": "2", "correct": "true" },
{ "value": "3", "correct": "false" },
{ "value": "4", "correct": "false" },
{ "value": "5", "correct": "false" }
],
"score": 10
},
{
"question": "1 + 2",
"options": [
{ "value": "2", "correct": "false" },
{ "value": "3", "correct": "true" },
{ "value": "4", "correct": "false" },
{ "value": "5", "correct": "false" }
],
"score": 20
}
,
{
	"question": "3 + 2",
	"options": [
	{ "value": "2", "correct": "false" },
	{ "value": "3", "correct": "false" },
	{ "value": "4", "correct": "false" },
	{ "value": "5", "correct": "true" }
	],
	"score": 20
	}
	,
{
"question": "6 + 2",
"options": [
{ "value": "2", "correct": "false" },
{ "value": "3", "correct": "false" },
{ "value": "8", "correct": "true" },
{ "value": "5", "correct": "false" }
],
"score": 20
}
,
{
"question": "1 + 2",
"options": [
{ "value": "2", "correct": "false" },
{ "value": "3", "correct": "true" },
{ "value": "4", "correct": "false" },
{ "value": "5", "correct": "false" }
],
"score": 20
}
],
"userId": 1,
"token": "xxxyyy",
"noOfLife": 3,
"timeLimit": 60
}

var psnake = []
var tsnake = []
var options = []
var screensize

var nolives
var questions
var timelimit
var token
var userid
var noqs
var current_q
var correctanswered
var gametime
var aexited
var lastpx
var lastpy
var gameovercalled

var score = 0
onready var fruit = preload("res://src/fruit.tscn")
var f

var myjsdata

var gover
var m_over	
var mylang

func spawn_fruits():
	var q_box_x = gframe.get_rect().size.x/2
	var q_box_y = gframe.get_rect().size.y/2
	var ranges = [[100,q_box_x-150,100,q_box_y-150],[q_box_x,q_box_x*2-150,0,q_box_y-150],[0,q_box_x-150,q_box_y,q_box_y*2-150],[q_box_x,q_box_x*2-150,q_box_y,q_box_y*2-150]]

	for i in range(4):
		f = fruit.instance()
		gframe.add_child(f)
		options.append(f)
		f.connect("fruitgot",self,"respawn")
		var fpos = Vector2(rand_range(ranges[i][0],ranges[i][1]),
		rand_range(ranges[i][2],ranges[i][3]))
		randomize()
		while (fpos.x >= psnake[0].pos.x-50 and fpos.x<=psnake[0].pos.x+50 and 
		fpos.y >= psnake[0].pos.y+150 and fpos.y<=psnake[0].pos.y-150):
			fpos = Vector2(rand_range(ranges[i][0],ranges[i][1]),
		rand_range(ranges[i][2],ranges[i][3]))
			
		options[i].position = fpos
			
	
	options[0].optext.text = 'A'
	options[1].optext.text='B'
	options[2].optext.text='C'
	options[3].optext.text='D'

func get_range(ranges_already_gain):
	randomize()
	var my_c_i = int(rand_range(0,4))
	while ranges_already_gain[my_c_i]==true:
		randomize()
		my_c_i = int(rand_range(0,4))
	ranges_already_gain[my_c_i]=true
	return my_c_i

func respawn(txt):
	
	var qflag = false
	if gameflag==false:
		return
	
	var prev_score = score
	if current_q < questions.size():
		if txt=='A':
			if ttextjj==null:
				#when not on web and on godot engine
				if dataj['questions'][current_q]['options'][0]['correct']=="true":
					score+=dataj['questions'][current_q]['score']
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
			else:
				#when online on web
				if ttextjj['questions'][current_q]['options'][0]['correct']=="true":
					score+=int(ttextjj['questions'][current_q]['score'])
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
		elif txt=='B':
			if ttextjj==null:
				if dataj['questions'][current_q]['options'][1]['correct']=="true":
					score+=dataj['questions'][current_q]['score']
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
			else:
				if ttextjj['questions'][current_q]['options'][1]['correct']=="true":
					score+=int(ttextjj['questions'][current_q]['score'])
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
		elif txt=='C':
			if ttextjj==null:
				if dataj['questions'][current_q]['options'][2]['correct']=="true":
					score+=dataj['questions'][current_q]['score']
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
			else:
				if ttextjj['questions'][current_q]['options'][2]['correct']=="true":
					score+=int(ttextjj['questions'][current_q]['score'])
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
		elif txt=='D':
			if ttextjj==null:
				if dataj['questions'][current_q]['options'][3]['correct']=="true":
					score+=dataj['questions'][current_q]['score']
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
			else:
				if ttextjj['questions'][current_q]['options'][3]['correct']=="true":
					score+=int(ttextjj['questions'][current_q]['score'])
					correctanswered+=1
					if gameflag:
					   growsize()
					gscore.get_node("AnimationPlayer").current_animation = "scoreanim"
		if score==prev_score:
			if nolives>0:
				nolives-=1
				glives.get_node("AnimationPlayer").current_animation="liveanim"
			if nolives==0:
				qflag = true
		
		if current_q + 1 < questions.size():
			current_q+=1
			set_info_box_value()
		else:
			current_q+=1
			qflag=true
			set_info_box_value_answered()
	var ranges_already_gain = [false,false,false,false]	
	var q_box_x = gframe.get_rect().size.x/2
	var q_box_y = gframe.get_rect().size.y/2
	var ranges = [[0,q_box_x-150,0,q_box_y-150],[q_box_x,q_box_x*2-150,0,q_box_y-150],[0,q_box_x-150,q_box_y,q_box_y*2-150],[q_box_x,q_box_x*2-150,q_box_y,q_box_y*2-150]]	
	for i in range(4):
		var c_i = get_range(ranges_already_gain)
		var fpos
		var flag = true
		randomize()
		fpos = Vector2(rand_range(ranges[c_i][0],ranges[c_i][1]),
		rand_range(ranges[c_i][2],ranges[c_i][3]))
		while ((fpos.x >= psnake[0].pos.x-100 and fpos.x<=psnake[0].pos.x+100) or 
		(fpos.y >= psnake[0].pos.y-100 and fpos.y<=psnake[0].pos.y+100)):
			randomize()
			fpos = Vector2(rand_range(ranges[c_i][0],ranges[c_i][1]),
		rand_range(ranges[c_i][2],ranges[c_i][3]))
		options[i].position = fpos
	
	if Engine.iterations_per_second < 10:
		Engine.iterations_per_second+=1;
	
	if qflag:
		if not(gameovercalled):
			gameovercalled = true
			#yield(get_tree().create_timer(0.2), "timeout")
			game_over()
			gover = goverfor.instance()
			reset_infobox("correct answers:"+str(correctanswered)+" total questions:"+str(noqs)+" score:"+str(score))
			add_child(gover)
			#call_deferred("add_child",gover)
			#gover.get_node("MarginContainer/TextureRect/scoreshow").text = "Correct Answers: "+str(correctanswered)+"\nTotal Questions: "+str(noqs)+"\nScore: "+str(score)
			if get_tree().paused==false:
				get_tree().paused = true
	
			
func getrandom():
	var nums = [1,2,3,4,5,6,7,8,9,10] #list to choose from
	randomize()
	var N = nums[randi() % nums.size()]
	while N in global.visited:
		randomize()
		N = nums[randi() % nums.size()]
	if global.visited.size()==9:
		global.visited = []
	global.visited.push_back(N)
	return N			
			
func _ready():
	
	
	
	jflag = false
	gcontrols = gamecontrols.instance()
	gchoices = Choices.instance()
	gquestion = Question.instance()
	gprogress = Progress.instance()
	gscore = ScoreNode.instance()
	glives = Live.instance()
	glives.get_node("AnimationPlayer").current_animation="liveanim"
	
	add_child(gprogress)
	add_child(gcontrols)
	add_child(gquestion)
	add_child(gscore)
	add_child(glives)
	
	gquestion.get_node("question").visible = false
	add_child(gchoices)
	
	gchoices.get_node("holder/choice1").visible = false
	gchoices.get_node("holder/choice2").visible = false
	gchoices.get_node("holder/choice3").visible = false
	gchoices.get_node("holder/choice4").visible = false	
	gameovercalled = false
	Engine.iterations_per_second= 5
	aexited = false
	ttextjj= null
	myjsdata = null
	mylang = null
	load_data1()
	if OS.has_feature('JavaScript') and nolives==3:
		myjsdata =  JavaScript.eval(""" 
			  const queryString = window.location.search;
			
	  const urlParams = new URLSearchParams(queryString);
	
	  const id = urlParams.get("id");
	  const server = urlParams.get("server");
	  const userId = urlParams.get("userId");
	  const token = urlParams.get("token");
	  let thereturn = null;
	  const score = 100;
	  function sendResult() {
		console.log("sendResult");
		var formData = new FormData();
		formData.append("paperId", id);
		formData.append("score", score);
		formData.append("userId", userId);
		formData.append("token", token);

		var xhr = new XMLHttpRequest();
		// xhr.withCredentials=true
		xhr.open("POST", server + "/api/submitGameResult");
		xhr.send(formData);
		xhr.onreadystatechange = function () {
		  // If the request completed, close the extension popup
		  if (this.readyState == 4)
			if (this.status == 200) {
			  const response = JSON.parse(this.response);
			  console.log(response);

			  if (response.success) {
				// result submission succefully
				console.log("success");
			  } else {
				console.log("fail");
			  }
			}
		};
	  }
	  var getJSON = function (url, callback) {
		var xhr = new XMLHttpRequest();
		xhr.open("GET", url, true);
		xhr.responseType = "json";
		xhr.onload = function () {
		  var status = xhr.status;
		  if (status === 200) {
			callback(null, xhr.response);
		  } else {
			callback(status, xhr.response);
		  }
		};
		xhr.send();
	  };
	  function getRandomArbitrary(min, max) {
		
		return Math.random() * (max - min) + min;
	  }
	  let file_num = parseInt(getRandomArbitrary(1, 11));
	  
	thereturn = server + "/game/" + id + "/" + file_num.toString() + ".json";
	thereturn = server + "/game/" + id + "/";
	thereturn = "https://demo-backend.learning-canvas.com"+"/game/"+46+"/";
	
		""")
	   #thereturn = "https://demo-backend.learning-canvas.com"+"/game/"+46+"/";
		mylang =  JavaScript.eval(""" 
			  const queryString = window.location.search;
	  const urlParams = new URLSearchParams(queryString);
	  let temp = urlParams.get("lang");
	  
	  temp; 
	   """)
	
	if myjsdata!=null and ttextjj==null:
		if OS.has_feature('JavaScript') and global.buffer.size()==0 and global.replay1==false:
			$HTTPRequest.request(myjsdata+str(getrandom())+".json")
		else:
			if global.buffer.size()==0:
				
				ttextjj = default_json_data
			else:
				ttextjj = global.buffer.pop_front()
			load_data()
			if OS.has_feature('JavaScript') :
				$HTTPRequest2.request(myjsdata+str(getrandom())+".json")
			
				
	get_tree().paused = false
	var temp_pos = Vector2(0,0)
	screensize = get_viewport().size
	correctanswered=0
	load_data1()
	
	if myjsdata==null:
		load_data()
	if ttextjj!=null:
		load_data()
	for i in range(0,2):
		if i==0:
			psnake.append(sprite.instance())
			gframe.add_child(psnake[i])
			psnake[i].pos.x = temp_pos.x;
			psnake[i].pos.y = temp_pos.y;
			psnake[i].prevpos.x = psnake[i].pos.x
			psnake[i].prevpos.y = psnake[i].pos.y
		else:
			psnake.append(sprite2.instance())
			gframe.add_child(psnake[i])
			temp_pos.x-=32
			psnake[i].pos.x = temp_pos.x;
			psnake[i].pos.y = temp_pos.y;
			psnake[i].position = temp_pos
			#psnake[i].connect("headoverlap",self,"selfeat")
	tsnake.append(sprite3.instance())
	gframe.add_child(tsnake[0])
	temp_pos.x-=32
	tsnake[-1].pos.x = temp_pos.x;
	tsnake[-1].pos.y = temp_pos.y;
	tsnake[-1].position= temp_pos
	tsnake[-1].connect("taileat",self,"selfeat")
	tsnake.append(sprite4.instance())
	gframe.add_child(tsnake[1])
	temp_pos.x-=32
	tsnake[-1].pos.x = temp_pos.x;
	tsnake[-1].pos.y = temp_pos.y;
	tsnake[-1].position= temp_pos
	tsnake[-1].connect("taileatlast",self,"selfeat")
	
	gameflag = true
	gprogress.get_node("ProgressBar").connect("timebartimeout",self,"timebar_runout")
	gcontrols.connect("d",self,"move_down")
	gcontrols.connect("u",self,"move_up")
	gcontrols.connect("r",self,"move_right")
	gcontrols.connect("l",self,"move_left")
	
	spawn_fruits()
	set_physics_process(true)
	if nolives==3 and global.replay1==false:
		m_over = menuover.instance()
		add_child(m_over)
		
		if mylang=='zh':
			m_over.get_node("CanvasLayer2/Start-box/ReferenceRect/RichTextLabel").text='開始遊戲'
		else:
			m_over.get_node("CanvasLayer2/Start-box/ReferenceRect/RichTextLabel").text=' START'
		m_over.get_node("CanvasLayer/Area2D/CollisionShape2D").set_z_index(9)
		if OS.has_feature('JavaScript'):
			m_over.get_node("CanvasLayer2/Start-box/start").disabled = true
	
	if global.replay1:
		get_tree().paused = false
	
func set_info_box_value():
	if  str(score).length()==2:
		gscore.get_node("Score-bg/score").text = "  "+str(score)
	elif str(score).length()==1:
		gscore.get_node("Score-bg/score").text = "   "+str(score)
	else:
		gscore.get_node("Score-bg/score").text = str(score)
	glives.get_node("holder/lives").text = 'X '+str(nolives)
	gquestion.get_node("question").text = questions[current_q]['question']
	gchoices.get_node("holder/choice1").text = 'A) '+questions[current_q]['options'][0]['value']
	gchoices.get_node("holder/choice2").text = 'B) '+questions[current_q]['options'][1]['value']
	gchoices.get_node("holder/choice3").text = 'C) '+questions[current_q]['options'][2]['value']
	gchoices.get_node("holder/choice4").text = 'D) '+questions[current_q]['options'][3]['value']
	
func set_info_box_value_answered():
	if  str(score).length()==2:
		gscore.get_node("Score-bg/score").text = "  "+str(score)
	elif str(score).length()==1:
		gscore.get_node("Score-bg/score").text = "   "+str(score)
	else:
		gscore.get_node("Score-bg/score").text = str(score)
	glives.get_node("holder/lives").text = 'X '+str(nolives)
	gquestion.get_node("question").text = ''
	gchoices.get_node("holder/choice1").text = ''
	gchoices.get_node("holder/choice2").text = ''
	gchoices.get_node("holder/choice3").text = ''
	gchoices.get_node("holder/choice4").text = ''
	
func reset_infobox(txt):
	if  str(score).length()==2:
		gscore.get_node("Score-bg/score").text = "  "+str(score)
	elif str(score).length()==1:
		gscore.get_node("Score-bg/score").text = "   "+str(score)
	else:
		gscore.get_node("Score-bg/score").text = str(score)
	glives.get_node("holder/lives").text = 'X '+str(nolives)
	gchoices.get_node("holder/choice1").text = ''
	gchoices.get_node("holder/choice2").text = ''
	gchoices.get_node("holder/choice3").text = ''
	gchoices.get_node("holder/choice4").text = ''
	
func load_data():
	var file = File.new()
	if not(file.file_exists(pathj)):
		file.open(pathj,File.WRITE)
		file.store_var(default_json_data)
		file.close()
		
	if ttextjj!=null:
		pass
	else:
		file.open(pathj,file.READ)
		dataj = file.get_var()
		file.close()	
		
	if ttextjj!=null:
		nolives = ttextjj['noOfLife']
		timelimit = ttextjj['timeLimit']
		questions = ttextjj['questions']
		
		gprogress.get_node("ProgressBar/Timer").set_wait_time(float(ttextjj['timeLimit'])/100)
		gprogress.get_node("ProgressBar/Timer").start()
		noqs = questions.size()
		current_q=0
		set_info_box_value()
	else:
		nolives = dataj['noOfLife']
		timelimit = dataj['timeLimit']
		userid = dataj['userId']
		token = dataj['token']
		questions = dataj['questions']
		gprogress.get_node("ProgressBar/Timer").set_wait_time(float(dataj['timeLimit'])/100)
		gprogress.get_node("ProgressBar/Timer").start()
		noqs = questions.size()
		current_q=0
		set_info_box_value()
	if file.file_exists("user://"+file_name):
		var tempdataj
		file.open("user://"+file_name,file.READ)
		tempdataj = file.get_var()
		current_q = tempdataj['current question']
		correctanswered = tempdataj['correct answered']
		score = tempdataj['score']
		nolives = tempdataj['nolives']
		gprogress.get_node("ProgressBar").value = int(tempdataj['current timer value'])
		set_info_box_value()
	else:
		save_final_data()
		set_info_box_value()
		
func load_data1():
	
	
	
	#print("in load data1")
	var file = File.new()
	
	if not(file.file_exists("user://"+file_name)) or global.replay==false:
		global.replay = true
		file.open("user://"+file_name,File.WRITE)
		file.store_var({"current question":0,"correct answered":0,
	'score':0,'nolives':3,'current file':myjsdata,'current file data':null,'current timer value':100})
		file.close()
	
	file.open("user://"+file_name,file.READ)
	dataj = file.get_var()
	file.close()	
	#print('data j here',dataj)
	nolives = dataj['nolives']
	if nolives<3:
		if OS.has_feature('JavaScript'):
			myjsdata = dataj['current file']
			ttextjj = dataj['current file data']
	
func save_final_data():
	var file = File.new()
	file.open("user://"+file_name,File.WRITE)
	var mystoredata = {"current question":current_q,"correct answered":correctanswered,
	'score':score,'nolives':nolives,'current file':str(myjsdata),'current file data':ttextjj,
	'current timer value':gprogress.get_node("ProgressBar").value}
	file.store_var(mystoredata)
	file.close()
	
func motion(x,y):
	if(x!=psnake[0].pos.x or y!=psnake[0].pos.y):
		for i in range(1,psnake.size()):
			if psnake[i].pos.x+32==x and psnake[i].pos.y==y:
				x = psnake[i].pos.x
				y = psnake[i].pos.y
				psnake[i].move_right(32)
			elif psnake[i].pos.x-32==x and psnake[i].pos.y==y:
				x = psnake[i].pos.x
				y = psnake[i].pos.y
				psnake[i].move_left(32)
			elif psnake[i].pos.y-32==y and psnake[i].pos.x==x:
				x = psnake[i].pos.x
				y = psnake[i].pos.y
				psnake[i].move_up(32)
			elif psnake[i].pos.y+32==y and psnake[i].pos.x==x:
				x = psnake[i].pos.x
				y = psnake[i].pos.y
				psnake[i].move_down(32)
	psnake[0].prevpos.x = psnake[0].pos.x
	psnake[0].prevpos.y = psnake[0].pos.y

func motion1(x,y):
	for i in range(0,tsnake.size()):
		var myval
		if i==0:
			myval = 32
		else:
			myval=32
		if tsnake[i].pos.x+myval==x and tsnake[i].pos.y==y:
			x = tsnake[i].pos.x
			y = tsnake[i].pos.y
			tsnake[i].move_right(myval)
		elif tsnake[i].pos.x-myval==x and tsnake[i].pos.y==y:
			x = tsnake[i].pos.x
			y = tsnake[i].pos.y
			tsnake[i].move_left(myval)
		elif tsnake[i].pos.y-myval==y and tsnake[i].pos.x==x:
			x = tsnake[i].pos.x
			y = tsnake[i].pos.y
			tsnake[i].move_up(myval)
		elif tsnake[i].pos.y+myval==y and tsnake[i].pos.x==x:
			x = tsnake[i].pos.x
			y = tsnake[i].pos.y
			tsnake[i].move_down(myval)

func growsize():
	var x
	var y
	var flag = true
	if flag and gameflag:
		if psnake[-1].pos.x==psnake[-2].pos.x and psnake[-1].pos.y!=psnake[-2].pos.y:
			if psnake[-2].pos.y>psnake[-1].pos.y:
				x = psnake[-1].pos.x
				y = psnake[-1].pos.y-32
			elif psnake[-2].pos.y<psnake[-1].pos.y:
				x = psnake[-1].pos.x
				y = psnake[-1].pos.y+32
		elif psnake[-1].pos.x!=psnake[-2].pos.x and psnake[-1].pos.y==psnake[-2].pos.y:
			if psnake[-2].pos.x>psnake[-1].pos.x:
				x = psnake[-1].pos.x-32
				y = psnake[-1].pos.y
			elif psnake[-2].pos.x<psnake[-1].pos.x:
				x = psnake[-1].pos.x+32
				y = psnake[-1].pos.y
		psnake.append(sprite2.instance())
		gframe.add_child(psnake[-1])
		#gframe.call_deferred("add_child",psnake[-1])
		psnake[-1].pos.x = x;
		psnake[-1].pos.y = y;
		psnake[-1].position.x = x;
		psnake[-1].position.y = y;
		
		#psnake[-1].connect("headoverlap",self,"selfeat")
		
		if psnake[-1].pos.x==psnake[-2].pos.x and psnake[-1].pos.y!=psnake[-2].pos.y:
			if psnake[-2].pos.y>psnake[-1].pos.y:
				x = psnake[-1].pos.x
				y = psnake[-1].pos.y-32
				tsnake[0].endtail0.rotation_degrees = 90
			elif psnake[-2].pos.y<psnake[-1].pos.y:
				x = psnake[-1].pos.x
				y = psnake[-1].pos.y+32
				tsnake[0].endtail0.rotation_degrees = 90
		elif psnake[-1].pos.x!=psnake[-2].pos.x and psnake[-1].pos.y==psnake[-2].pos.y:
			if psnake[-2].pos.x>psnake[-1].pos.x:
				x = psnake[-1].pos.x-32
				y = psnake[-1].pos.y
				tsnake[0].endtail0.rotation_degrees = 0
			elif psnake[-2].pos.x<psnake[-1].pos.x:
				x = psnake[-1].pos.x+32
				y = psnake[-1].pos.y
				tsnake[0].endtail0.rotation_degrees = 0
		
		tsnake[0].pos.x = x
		tsnake[0].pos.y = y
		tsnake[0].position.x = x;
		tsnake[0].position.y = y;
		
		if tsnake[0].pos.x==psnake[-1].pos.x and tsnake[0].pos.y!=psnake[-1].pos.y:
			if psnake[-1].pos.y>tsnake[0].pos.y:
				x = tsnake[0].pos.x
				y = tsnake[0].pos.y-32
				tsnake[1].endtail.rotation_degrees = 90
			elif psnake[-1].pos.y<tsnake[0].pos.y:
				x = tsnake[0].pos.x
				y = tsnake[0].pos.y+32
				tsnake[1].endtail.rotation_degrees = 90
		elif tsnake[0].pos.x!=psnake[-1].pos.x and tsnake[0].pos.y==psnake[-1].pos.y:
			if psnake[-1].pos.x>tsnake[0].pos.x:
				x = tsnake[0].pos.x-32
				y = tsnake[0].pos.y
				tsnake[1].endtail.rotation_degrees = 0
			elif psnake[-1].pos.x<tsnake[0].pos.x:
				x = tsnake[0].pos.x+32
				y = tsnake[0].pos.y
				tsnake[1].endtail.rotation_degrees = 0
		
		tsnake[1].pos.x = x
		tsnake[1].pos.y = y
		tsnake[1].position.x = x;
		tsnake[1].position.y = y;
		
# for screen arrows
func move_up() -> void:
	psnake[0].move_up(32)

func move_right() -> void:
	psnake[0].move_right(32)

func move_left() -> void:
	psnake[0].move_left(32)

func move_down() -> void:
	psnake[0].move_down(32)


func selfeat():
	if nolives-1 >0 and current_q<  questions.size():
		save_final_data()
		#timerr.set_wait_time(0.1)
		#timerr.start()
		#$snakedead.play()
		get_tree().reload_current_scene()
	else:
		if not(gameovercalled):
			nolives-=1
			game_over()
			gover = goverfor.instance()
			reset_infobox("correct answers:"+str(correctanswered)+"\ntotal questions:"+str(noqs)+"\nscore:"+str(score))
			add_child(gover)
			#gover.get_node("MarginContainer/TextureRect/scoreshow").text = "Correct Answers: "+str(correctanswered)+"\nTotal Questions: "+str(noqs)+"\nScore: "+str(score)
			#$snakedead.play()
			if get_tree().paused==false:
				get_tree().paused = true
							
	
		
func _physics_process(delta):
	if gameflag:
		if not(jflag):
			jflag = true
			gquestion.get_node("question").visible = true
			gchoices.get_node("holder/choice1").visible = true
			gchoices.get_node("holder/choice2").visible = true
			gchoices.get_node("holder/choice3").visible = true
			gchoices.get_node("holder/choice4").visible = true	
		for i in range(1,psnake.size()):
			if ( ( i < psnake.size() and ( psnake[0].pos.x<=psnake[i].pos.x and psnake[0].pos.x>=psnake[i].pos.x-20) and ( psnake[0].pos.y<=psnake[i].pos.y and psnake[0].pos.y>=psnake[i].pos.y-20) )
			or ((psnake[0].pos.x<=tsnake[0].pos.x and psnake[0].pos.x>=tsnake[0].pos.x-20) and (psnake[0].pos.y<=tsnake[1].pos.y and psnake[0].pos.y>=tsnake[1].pos.y-20)) 
			 ):
					gameflag=false
					if nolives-1 >0 and current_q<  questions.size():
						save_final_data()
						#timerr.set_wait_time(0.1)
						#timerr.start()
						#$snakedead.play()
						get_tree().reload_current_scene()
						break
					else:
						if not(gameovercalled):
							nolives-=1
							game_over()
							gover = goverfor.instance()
							reset_infobox("correct answers:"+str(correctanswered)+"\ntotal questions:"+str(noqs)+"\nscore:"+str(score))
							add_child(gover)
							#gover.get_node("MarginContainer/TextureRect/scoreshow").text = "Correct Answers: "+str(correctanswered)+"\nTotal Questions: "+str(noqs)+"\nScore: "+str(score)
							#$snakedead.play()
							if get_tree().paused==false:
								get_tree().paused = true
							break
			
	
	psnake[0].prevpos.x = psnake[0].pos.x
	psnake[0].prevpos.y = psnake[0].pos.y
	psnake[0].pos+=psnake[0].get_vel()
	if gameflag:
		psnake[0].position = psnake[0].pos
	if psnake[0].prevpos.x!=psnake[0].pos.x or psnake[0].prevpos.y!=psnake[0].pos.y:
		lastpx = psnake[-1].pos.x
		lastpy = psnake[-1].pos.y
		if gameflag:
			motion(psnake[0].prevpos.x,psnake[0].prevpos.y)
			motion1(lastpx,lastpy)
	else:
		pass
		
func game_over():
	gameovercalled = true
	reload = true
	set_info_box_value_answered()
	glives.get_node("AnimationPlayer").current_animation="liveanim"
	var file = File.new()
	#file.open("res://gamestate.json",File.WRITE)
	if OS.has_feature('JavaScript'):
		JavaScript.eval("""
		
		String.prototype.hashCode = function() {
	var hash = 0;
	if (this.length == 0) {
		return hash;
	}
	for (var i = 0; i < this.length; i++) {
		var char = this.charCodeAt(i);
		hash = ((hash<<5)-hash)+char;
		hash = hash & hash; 
	}
	return hash;
	  }
	
		const queryString = window.location.search;
	  const urlParams = new URLSearchParams(queryString);
	const keys = urlParams.keys();
	
	  const id = urlParams.get("id");
	  const server = urlParams.get("server");
	  const userId = urlParams.get("userId");
	  const token = urlParams.get("token");

	  const score = \'%s\';
	
	  var hashed_score = id+score;
	  //console.log(hashed_score.hashCode());

	  function sendResult() {
		
		var formData = new FormData();
		
		for (const key of keys) {
			if (key==="id")
				formData.append("paperId", urlParams.get(key));
			else if(key!=="server" && key!=="lang")
				formData.append(key, urlParams.get(key));
			}
		formData.append("score", score);
		formData.append("hashcode", hashed_score.hashCode());

		var xhr = new XMLHttpRequest();
		// xhr.withCredentials=true
		xhr.open("POST", server + "/api/submitGameResult");
		xhr.send(formData);
		xhr.onreadystatechange = function () {
		  // If the request completed, close the extension popup
		  if (this.readyState == 4)
			if (this.status == 200) {
			  const response = JSON.parse(this.response);
			  //console.log(response);

			  if (response.success) {
				// result submission succefully
				//console.log("success");
			  } else {
				//console.log("fail");
			  }
			}
		};
	  }
	
	  sendResult();
	
	
		"""%score)
	file.open("user://"+file_name,File.WRITE)
	var mystoredata = {"current question":0,"correct answered":0,
	'score':0,'nolives':3,'current file':null,'current timer value':100}
	#print(mystoredata)
	file.store_var(mystoredata)
	file.close()
	
func _on_Area2D_area_exited(area: Area2D) -> void:
	
	if area.get_name()=="snake-head":
		if nolives-1 >0 and current_q<questions.size():
			aexited = true
			nolives-=1
			save_final_data()
			#timerr.set_wait_time(0.06)
			#timerr.start()
			#$snakedead.play()
			get_tree().reload_current_scene()
		else:
			if not(gameovercalled):
				nolives-=1
				game_over()
				gover = goverfor.instance()
				reset_infobox("correct answers:"+str(correctanswered)+" total questions:"+str(noqs)+" score:"+str(score))
				add_child(gover)
				#gover.get_node("MarginContainer/TextureRect/scoreshow").text = "Correct Answers: "+str(correctanswered)+"\nTotal Questions: "+str(noqs)+"\nScore: "+str(score)
				#$snakedead.play()
				if get_tree().paused==false:
					get_tree().paused = true
				
func _notification(input_state):
	#when offline and close window is triggered
	if (input_state == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		nolives=0
		game_over()
		get_tree().quit() # default behavior		
		
func timebar_runout():
	gameflag = false
	#print("in time bar runout")
	if not(gameovercalled):
		gameovercalled = true
		nolives = 0
		game_over()
		gover = goverfor.instance()
		reset_infobox("correct answers:"+str(correctanswered)+"\ntotal questions:"+str(noqs)+"\nscore:"+str(score))
		add_child(gover)
		if get_tree().paused==false:
			get_tree().paused = true
		#gover.get_node("MarginContainer/TextureRect/scoreshow").text = "Correct Answers: "+str(correctanswered)+"\nTotal Questions: "+str(noqs)+"\nScore: "+str(score)
		
		

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	ttextjj = json.result
	if response_code==200:
		print("")
	else:
		ttextjj = default_json_data
	randomize()
	$HTTPRequest2.request(myjsdata+str(getrandom())+".json")
	load_data()
	#m_over.get_node("CanvasLayer2/Start-box/start").disabled = false


func _on_HTTPRequest2_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	
	if response_code==200:
		
		global.buffer.push_back(json.result)
	else:
		
		global.buffer.push_back(default_json_data)
	if global.replay1==false:
		m_over.get_node("CanvasLayer2/Start-box/start").disabled = false
	else:
		get_tree().paused = false
