extends Node3D
#Script Principal del manejo de los anillos
#Encargado de la aparición de sus pilares

#Variables
var Tile=preload("uid://c0etqnj18lw6s")
var TileSpeed:Vector3 = Global.TileSpeed
var TileAmount = Global.TileAmount
var TileDistance = Global.TileDistance
var LastDistance
var SpawnDown = true
var ShrinkTiles = false
var Ring = 0
var RingN
var Spin=true
var dir
var tween
var CoinsAmount:int=0
var CoinsN:int=0

func _ready() -> void:
	#Crear cantidad de monedas que pueden aparecer
	CoinsAmount=randi_range(1,3)
	dir = 1 if randi_range(0,1)==1 else -1
	CreateRing()#Función para crear anillo

func _physics_process(delta: float) -> void:#Función activa todo el tiempo encargada de los procesos físicos del script
	if Spin and !Global.Paused:#Verificar si el anillo puede girar
		rotation_degrees += TileSpeed * delta  * dir#Aplicar rotación al anillo

func CreateRing():#Función para crear anillo
	if randi_range(1,3) == 3:#Función aleatoria para asignar escalado a los pilares
		ShrinkTiles = true
	
	Global.RingN += 1#Asignar ID al anillo
	RingN = Global.RingN#Número de anillo correspondiente del valor Global 
	var degto=float(360)/TileAmount#Calcular posiciones de los pilares
	position.y = -5 if SpawnDown else 0#Crear posición vertical de aparición de los pilares
	
	for n in TileAmount:#Bucle para generar pilares
		var Tilex = Tile.instantiate()#Instanciar escena de pilar
		
		if randi_range(1,10) >= 9 and CoinsN<CoinsAmount:#Crear probabilidad de aparición de monedas
			CoinsN+=1#Cambiar espacios de monedas a generar
			Tilex.SpawnCoin=true#Generar monedas
		
		#Lógica para determinar rotación y posición de los pilares
		Tilex.position = Vector3(TileDistance * cos(deg_to_rad(degto*n)),0,TileDistance * sin(deg_to_rad(degto*n)))
		Tilex.TileN = n
		Tilex.TileDistanceTo = TileDistance
		Tilex.rotation_degrees.y = degto*n
		Tilex.GameTile = true#Determinar si el pilar es de anillo o independiente
		
		if ShrinkTiles and n%2==0:#Función para cambiar escalado de pilares que pueden cambiar de tamaño
			Tilex.scale = Vector3(.75,1,.75)
		
		add_child(Tilex)#Añadir escena de pilar
	
	tween = create_tween()#Crear animación
	if !Global.Paused:#Verificar que el juego no este pausado para continuar con la animación
		tween.tween_property(self,"position",Vector3.ZERO,1.5).set_ease(Tween.EASE_IN)#Propiedades de la animación
