extends CharacterBody3D
#Script para la generación de anillos y manejo de propiedades
#

#Variables
var InitPos
var ShrinkTile = false
var PosList = []
var TileN
var SpawnCoin
var GameTile = false
var VanishTile = false
var TileDistanceTo
var COIN = preload("uid://bbmjfyhaneapt").instantiate()

func _ready() -> void:
	for n in 6:#Bucle para añadir anillos a la Lista de anillos global 
		PosList.append(Global.TileDistance*n)
	#Asignar skin del pilar a partir de los Datos del Usuario
	var TileT = "res://Game/Assets/Tiles/"+str(Global.GameData.ActualTile)+".glb"
	
	var TileType = load(TileT).instantiate()
	TileType.scale=Vector3(.25,.25,.25)
	TileType.position.y=-0.725
	add_child(TileType)#Añadir escena del pilar
	
	if SpawnCoin:#Generar moneda
		var Coi = COIN
		Coi.position.y = 1
		add_child(Coi)#Añadir moneda al pilar
	InitPos = position
	if GameTile:#Añadir propiedad del pilar de poder encoger el anillo al que pertenece
		if get_parent().ShrinkTiles:
			ShrinkTile = true#Flag para encoger anillo

func _physics_process(_delta: float) -> void:#Función activa todo el tiempo encargada de los procesos físicos del script
	if GameTile:
		if ShrinkScale:
			ShrinkScale()#Función para encoger el pilar

func ShrinkScale():#Función encargada de encoger el pilar y agrandar el pilar
	if !Global.Paused:#Verificar que el juego no este en pausa
		if  ShrinkTile and TileN%2==0:#Verificar que el pilar sea par
			var tween = create_tween()#Crear animación
			#Propiedades de la animación
			tween.tween_property(self,"scale",Vector3(.65,1,.65),1.5).set_ease(Tween.EASE_IN)
			await tween.finished#Esperar al fin de la animación
			await  get_tree().create_timer(5).timeout#Crear temporizador
			ShrinkTile=false#Cambiar flag para encoger el pilar
		else:
			var tween = create_tween()#Crear animación
			#Propiedades de la animación
			tween.tween_property(self,"scale",Vector3(1,1,1),1.5).set_ease(Tween.EASE_OUT)
			await tween.finished#Esperar al fin de la animación
			await  get_tree().create_timer(5).timeout#Crear temporizador
			ShrinkTile=true#Cambiar flag para encoger el pilar

func Shrink(R:int,ang:float):#Función para encoger el anillo
	if !Global.Paused:#Verificar que el juego no este en pausa
		if get_parent().Ring == R:#Verificar que el anillo tenga el mismo ID para encogerlo
			var tween = create_tween()#Crear animación
			#Propiedades de la animación
			tween.tween_property(self,"position",Vector3(PosList[R] * sin((ang)),0,PosList[R] * cos((ang))),1.5).set_ease(Tween.EASE_OUT)
			await tween.finished#Esperar al fin de la animación
			if R == PosList[0]:#Verificar ID del anillo para eliminarlo al llegar al inicio
				Global.RingsList.erase(get_parent())#Borrar anillo de la Lista Global de anillos
				get_parent().queue_free()#Eliminar anillo
