extends Node

@export var cell :PackedScene
var cells:Array
var values:Array
var tableV:Array
var rng = RandomNumberGenerator.new()
var cell_size=50

# Called when the node enters the scene tree for the first time.
func _ready():
	cells=create_array(10,12)
	cells=charge_mines(cells,12)
	cells=values_mines(cells)
	values=charge_array(cells)
	draw_table()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_array(x,y):
	var arr=[]
	for  i in range(x):
		arr.append([])
		for j in range(y):
			arr[i].append(0)
			
	return arr
	
func charge_mines(a,c):
	var posic=[]
	var listA=charge_array(a)
	for x in range(c):
		var it=listA[rng.randi_range(0,len(listA))]
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
			if (x-xi>0 and x-xi<len(a))and (y-yi>0 and y-yi<len(a[0])) and not(xi==0 and yi==0):
				
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
