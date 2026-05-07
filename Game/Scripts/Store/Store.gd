extends CanvasLayer
#Script de la UI de Tienda
@export var Coins:RichTextLabel
var LastCoins

func _ready() -> void:
	#Asignar valores UI a partir de Datos Globales
	Coins.text = "Monedas: "+str(int(Global.GameData.Coins))
	LastCoins = Global.GameData.Coins

func _process(_delta: float) -> void:#Función activa todo el tiempo encargada de los procesos del script
	if LastCoins != Global.GameData.Coins:#Cambiar valores UI a partir del cambio de los valores de los Datos Globales
		LastCoins = Global.GameData.Coins
		Coins.text = "Monedas: "+str(int(Global.GameData.Coins))

func Exit() -> void:#Función para salir de la tienda al presionar el botón Exit
	get_parent().show()#Mostrar nodo padre
	queue_free()#Eliminar escena propia
