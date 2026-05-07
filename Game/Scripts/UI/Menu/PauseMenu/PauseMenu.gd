extends CanvasLayer

func _ready() -> void:
	hide()#Ocultar UI Menú de pausa

func _input(_event: InputEvent) -> void:#Función para detectar entradas Teclado/Mouse
	if Input.is_action_just_pressed("Pause") and !Global.GameOver:#Verificar Activación de la tecla Pausa
		Global.Pause()#Función Global para activar Pausa

func _process(_delta: float) -> void:#Función activa todo el tiempo encargada de los procesos del script
	if Global.Paused and !Global.GameOver:#Verificar si el juego esta en pausa
		show()#Mostrar UI Menú de Pausa
	else:
		hide()#Ocultar UI Menú de Pausa

func Continue() -> void:#Función para continuar el juego al presionar el botón de Continue
	Global.Pause()#Función Global para desactivar Pausa
	hide()#Ocultar UI Menú de Pausa

func Settings() -> void:#Función para abrir el menú de ajustes al presionar el botón de Settings
	var SETTINGS = preload("uid://3e6xcynebm22").instantiate()#Instanciar UI de Ajustes
	add_child(SETTINGS)#Adañir a la escena el Menú de Ajustes

func Menu() -> void:#Función para abrir el menú de ajustes al presionar el botón de Menú
	Transition.StartTransition()#Iniciar animación de transición para ir al menú
	Global.Pause()#Función Global para desactivar Pausa
