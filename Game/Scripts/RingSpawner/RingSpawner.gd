extends Node3D
#Script Encargado en la aparición de anillos

#Variables
var TileDistance = Global.TileDistance
var TileSpeed = Global.TileSpeed
const RING = preload("uid://b6ky3go377qw7")

func _ready() -> void:
	InitRings(5)#Función para generar anillos de inicio
	Global.Spawner = self#Definir variable Global como generador de anillos

func AddRing():#Función para añadir anillos
	var TempVel=Vector3(0,randi_range(35,70),0)#Asignar velocidad de rotación random del anillo
	var rino=RING.instantiate()#Instanciar anillo
	#Definir propiedades del anillo
	rino.Ring = 4
	rino.name="Ring #"+str(rino.Ring)
	rino.LastDistance=TileDistance
	rino.TileDistance=Global.TileDistance*5
	rino.TileSpeed=TempVel
	Global.RingsList.append(rino)
	add_child(rino)#Añadir escena del anillo

func InitRings(amount: int):#Función para crear "n" cantidad de anillos al iniciar el juego
	var TempDistance=0
	for n in amount:#Bucle para generar "n" cantidad de anillos solicitados
		#Variables del anillo
		var TempVel=Vector3(0,randi_range(35,70),0)
		TempDistance+=Global.TileDistance
		var rin=RING.instantiate()
		
		rin.name="Ring #"+str(n)
		rin.Ring = n
		rin.LastDistance=TileDistance
		rin.TileDistance=TempDistance
		rin.TileSpeed=TempVel
		rin.SpawnDown= false
		Global.RingsList.append(rin)#Añadir anillo a la lista de anillos Global
		add_child(rin)#Añadir escena de anillo
