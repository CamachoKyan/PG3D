extends CanvasLayer
#Script para detectar el Game Over y cargar pantalla UI de Menu Game Over

#Variables
@export var Content:Control
@export var ScoreL:RichTextLabel
@export var RecordL:RichTextLabel
@export var TheTimer:RichTextLabel

var Restart=false#Indicar si se esta reiniciando el juego
func _ready() -> void:
	visible = false#Desactivar visibilidad de la UI al iniciar 
	Content.position.y = -648.0#Cambiar posición del UI

func _process(_delta: float) -> void:#Función activa todo el tiempo encargada de los procesos del script
	#Verificación de puntajes
	if Global.GameOver and !Restart:
		if Global.Score>Global.GameData.BestScore:#Lógica para cambiar valor del record
			Global.GameData.BestScore=Global.Score
			if Global.Chrono>Global.GameData.BestTime:#Lógica para cambiar valor del tiempo record 
				Global.GameData.BestTime = Global.Chrono
		
		ScoreL.text = "Puntuación: "+str(Global.Score)#Cambiar UI de la puntuación del jugador
		#Formateo de variables para asignar a la UI 
		var m = int(Global.GameData.BestTime/60.0)
		var s = Global.GameData.BestTime - m *60
		TheTimer.text = "Tiempo Record: " + '%02dm:%02ds' % [m,s]#Asignar valor a UI
		#Formateo de variables para asignar a la UI 
		m = int(Global.GameData.BestTime/60.0)
		s = Global.GameData.BestTime - m *60
		
		RecordL.text = "Record: "+str(int(Global.GameData.BestScore))#Asignar valor a UI
		Global.Save()#Guardar Datos
		
		visible = true#Cambiar visibilidad de la UI a verdadero
		var tween = create_tween()#Crear animación tween
		tween.tween_property(Content,"position",Vector2(0,0),.75).set_ease(Tween.EASE_IN)#Propiedades de la animación tween
		
		await tween.finished#Esperar finalización de la animación para eliminarla
		tween.kill()#Eliminar animación

func Play() -> void:#Función para reiniciar el juego al presionar el botón de Play
	Restart=true#Marcar reinicio del juego
	var tween = create_tween()#Crear animación
	tween.tween_property(Content,"position",Vector2(0,-648),.5).set_ease(Tween.EASE_IN)
	await tween.finished#Esperar fin de la animación
	visible = false#Cambiar visibilidad del UI GameOver
	Transition.StartTransition(true)#Iniciar animación de transición para reiniciar el juego

func Settings() -> void:#Función para abrir el menú de ajustes al presionar el botón de Settings
	var SETTINGS = preload("uid://3e6xcynebm22").instantiate()#Instanciar escena UI Ajustes
	add_child(SETTINGS)#Añadir escena UI Ajustes

func Menu() -> void:#Función para abrir el menú de ajustes al presionar el botón de Menú
	Transition.StartTransition()#Iniciar animación de transición para ir al menú
