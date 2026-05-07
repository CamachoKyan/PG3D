extends Node
#Script Global Controlador de Audio
#Encargado de manejar todos los sonidos del juego

#Variables
@export var Master:AudioStreamPlayer
@export var Menu:AudioStreamPlayer
@export var Chicken:AudioStreamPlayer
@export var Coin:AudioStreamPlayer

func _ready() -> void:
	#Establecer el volumen a partir de los Ajustes al iniciar el juego
	AudioServer.set_bus_volume_db(0,linear_to_db(Global.GameData.Audio.Master))
	AudioServer.set_bus_volume_db(1,linear_to_db(Global.GameData.Audio.Music))
	AudioServer.set_bus_volume_db(2,linear_to_db(Global.GameData.Audio.SFX))
	#Iniciar música
	Master.play()
	Menu.play()
	#Establecer la música en loop
	Master.stream.loop = true
	Menu.stream.loop = true

#region Sounds
#Funciones encargadas de reproducir música/sonidos
#Desde cualquier otro script
func Playing():
	#Invertir volumen de las músicas
	Master.volume_db = 0
	Menu.volume_db = -80

func InMenu():
	#Invertir volumen de las músicas
	Master.volume_db = -80
	Menu.volume_db = 0

func Coins():#Reproducir sonido de moneda
	Coin.play()
#endregion

func _process(_delta: float) -> void:#
	if Global.GameOver:
		InMenu()
