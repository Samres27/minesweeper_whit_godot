extends Node

@export var cell :PackedScene
var cells:Array
var values:Array
var tableV:Array
var valuesCells:Array
var rng = RandomNumberGenerator.new()
var cell_size=50
var n_mines=12
var freeCells:int
# Called when the node enters the scene tree for the first time.
func _ready():
	cells=create_array(10,12)
	cells=charge_mines(cells,n_mines)
	cells=values_mines(cells)
	values=charge_array(cells)
	valuesCells=charge_vales(cells)
	freeCells=10*12-n_mines
	draw_table()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _input(event):
	detectAction()
	
func detectAction():
	if Input.is_action_pressed("click_left"):
		var position= get_viewport().get_mouse_position()
		found_changeL(position)
	if Input.is_action_pressed("click_rigth"):
		var position= get_viewport().get_mouse_position()
		found_changeR(position)
		
func found_changeL(position):
	var cellVaule=Vector2(int(position.x / cell_size),int(position.y / cell_size))
	var pos=values.bsearch(cellVaule)
	var valueMine=cells[cellVaule.x][cellVaule.y]
	if valuesCells[pos]!='u':
		if valueMine==-1: #mine
			game_over()
		elif valueMine==0:
			clean(cellVaule)
		else:
			tableV[pos].change_sprite('n'+str(valueMine))
			valuesCells[pos]='u'
		
		if valuesCells.count('u')==freeCells:
			win()
	
func found_changeR(position):
	var cellVaule=Vector2(int(position.x / cell_size),int(position.y / cell_size))
	print(cellVaule)
	var pos=values.bsearch(cellVaule)
	if valuesCells[pos]=='n':
		tableV[pos].change_sprite('flag')
		valuesCells[pos]='f'
	elif valuesCells[pos]=='f':
		tableV[pos].change_sprite('Default')
		valuesCells[pos]='n'
	
func clean(Vpos):
	if Vpos.x>=0 and Vpos.x<len(cells) and Vpos.y>=0 and Vpos.y<len(cells[0]):
		var valueMine=cells[Vpos.x][Vpos.y]
		var pos=values.bsearch(Vpos)
		if valuesCells[pos]!='u':
			if valueMine==0:
				valuesCells[pos]='u'
				tableV[pos].change_sprite('free')
				clean(Vpos+Vector2(0,1))
				clean(Vpos+Vector2(0,-1))
				clean(Vpos+Vector2(-1,0))
				clean(Vpos+Vector2(1,0))
			else:
				tableV[pos].change_sprite('n'+str(valueMine))
				valuesCells[pos]='u'
			
	
func game_over():
	print("gameOver:Bro")
	view_all_mines()

func win():
	print("congratulations, you win")
func create_array(x,y):
	var arr=[]
	for  i in range(x):
		arr.append([])
		for j in range(y):
			arr[i].append(0)
			
	return arr
	
func view_all_mines():
	var i=0
	for x in values:
		valuesCells[i]='u'
		if cells[x.x][x.y]==-1:
			tableV[i].change_sprite("mine")
		i+=1;
func charge_vales(a):
	var arr=[]
	for x in range(len(a)):
		for y in range(len(a[0])):
			arr.append('n')
	return arr

func charge_mines(a,c):
	var posic=[]
	var listA=charge_array(a)
	for x in range(c):
		var it=listA[rng.randi_range(0,len(listA)-1)]
		posic.append(it)
		listA.erase(it)
	
	for x in posic:
		a[x.x][x.y]=-1
		
	return a

func charge_array(a):
	var lista=[]
	for x in range(len(a)):
		for y in range(len(a[0])):
			lista.append(Vector2(x,y))
	return lista


func values_mines(a):
	for x in range(len(a)):
		for y in range(len(a[0])):
			if a[x][y]!=-1:a[x][y]=count_mines(x,y,a)
	return a
	
func count_mines(x,y,a):
	var cont=0;
	
	for xi in range(-1,2):
		for yi in range(-1,2):
			if (x-xi>=0 and x-xi<len(a))and (y-yi>=0 and y-yi<len(a[0])) and not(xi==0 and yi==0):
				
				if a[x-xi][y-yi]==-1:
					cont+=1
		
				print()
	return cont  

func draw_table():
	for x in values:
		var unit= cell.instantiate()
		unit.position=(x*cell_size)+Vector2(cell_size,cell_size)*0.5
		add_child(unit)
		tableV.append(unit)
