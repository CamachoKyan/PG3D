extends CanvasLayer
#Script encargado en la UI de puntuaciones

@export var RLabel:RichTextLabel
@export var CoinsLabel:RichTextLabel
@export var Chrono:RichTextLabel
@export var TheTimer:Timer

var LastScore
var LastCoins
var canstart = false

func _ready() -> void:
	#Crear cronometro
	Global.TheTimer = TheTimer
	#Asignar puntuación a UI
	RLabel.text = "Puntuación: "+str(Global.Score)
	LastScore=Global.Score
	LastCoins = 0

func _process(delta: float) -> void:
	if Global.PlayerCanMove:#Verificar que el jugador se puede mover
		if !canstart:#Verificar que el juego ya ha iniciado
			#Iniciar cronometro
			TheTimer.autostart = true
			TheTimer.start()
			canstart = true
	
	if Global.Score>=LastScore and delta:#Verificar cambio de puntuación
		#Cambio de UI puntuaciones
		RLabel.text = "Puntuación: "+str(Global.Score)
		LastScore=Global.Score
		
	if Global.GameData.Coins>=LastCoins:#Verificar cambio de monedas
		#Cambio de UI Monedas
		CoinsLabel.text = "Monedas: "+str(int(Global.GameData.Coins))
		LastCoins=Global.GameData.Coins

func Chronos() -> void:#Función de cronometro
	Global.Chrono +=1#Guardar tiempo del cronometro
	
	#Formateo de tiempo del cronometro
	var m = int(Global.Chrono/60.0)
	var s = Global.Chrono - m *60
	Chrono.text = "Tiempo: " + '%02dm:%02ds' % [m,s]#Cambiar UI Cronometro
