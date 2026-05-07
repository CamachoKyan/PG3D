extends Node
#Script Global encargado de las variables globales de todo el juego
#Accesible desde cualquier Script

#region Tiles
#Variables encargadas de valores de las plataformas
var TileSpeed:Vector3 = Vector3(0,50,0)
var TileAmount = 8
var TileDistance = 5
#endregion

#region Rings
#Variables encargadas de los anillos donde se instanciaran las plataformas
var RingsList:Array = []
var Spawner
var RingN = 0
#endregion

#region Scores
#Variables de puntuación
var Score:int = 0
var Chrono:int=0
var TheTimer:Timer
#endregion

#region Global Values
#Valores Globales para manejar la lógica del juego
var GameOver= false
var PlayerCanMove=false
var Paused = false
#endregion

func Pause():#Función encargada de la pausa del juego
	#Switch para cambiar estado de pausa del juego
	if Paused:
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	Paused = !Paused

func RestartGame():#Función encargada de reiniciar los valores del juego al iniciar una nueva ronda
	RingsList = []
	Score = 0
	RingN = 0
	RingN = 0
	TileSpeed = Vector3(0,50,0)
	TileAmount = 8
	TileDistance = 5
	Chrono = 0
	GameOver = false
	get_tree().change_scene_to_file("uid://bkwyto81gxne0")

#region Save & Load System
#Sistema de Guardado y Cargar Juego
const FilePath = "user://Save.json"#Archivo con datos del jugador

var Data:Dictionary

#Valores Globales del sistema de carga y guardado del juego
#Funcionan como valores default al iniciar por primera vez el juego
var GameData:Dictionary ={
	BestScore=int(0),
	BestTime=int(0),
	Coins = 0,
	Skins={
		Pollo_0={
			buyed=true,
			price=0
		},
		Pollo_1={
			buyed=false,
			price=50
		},
		Pollo_2={
			buyed=false,
			price=100
		},
		Pollo_3={
			buyed=false,
			price=200
		}
	},
	Tiles={
		Pilar_0={
			buyed=true,
			price=0
		},
		Pilar_1={
			buyed=false,
			price=50
		},
		Pilar_2={
			buyed=false,
			price=100
		},
		Pilar_3={
			buyed=false,
			price=200
		}
	},
	ActualSkin = "Pollo_0",
	ActualTile = "Pilar_0",
	Audio = {
		Master=1,
		Music=1,
		SFX=1
	}
}

func Save():#Función para guardar los datos del jugador
	var File = FileAccess.open(FilePath, FileAccess.WRITE)#Crear archivo de guardado de Datos
	File.store_string(JSON.stringify(GameData))#Formatear Archivo Dictionary en JSON y Guardarlo
	File.close()#Cerrar archivo
 
func Load():#Función para cargar los datos del jugador
	if FileAccess.file_exists(FilePath):#Verifica si el archivo existe, sino, se cargan los valores por defecto
		var File = FileAccess.open(FilePath, FileAccess.READ)#Leer Datos del archivo de guardado
		Data = JSON.parse_string(File.get_as_text())#Guardar los datos en una variable despues de ser recuperados del archivo de guardado en formato JSON
		GameData = Data.duplicate()#Asignar Datos Globales a partir de 
		
		for i in Data:#Reasignar datos 
			if GameData.has(i):
				GameData[i] = Data[i]
		File.close()#Cerrar archivo
#endregion

func _ready() -> void:
	Load()#Cargar Datos del juego al iniciarlo
