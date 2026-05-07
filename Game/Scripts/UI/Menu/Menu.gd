extends CanvasLayer
#Pantalla de menú principal

#Variables
var tween
func _ready() -> void:
	AudioController.InMenu()#Reproducir música de menú
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE#Cambiar vista del mouse

func Start() -> void:#Función para iniciar el juego al presionar el botón de Start
	Transition.StartTransition(true)#Iniciar animación de transición para iniciar el juego

func Settings() -> void:#Función para abrir el menú de ajustes al presionar el botón de Settings
	var SETTINGS = preload("uid://3e6xcynebm22").instantiate()#Instanciar UI de Ajustes
	add_child(SETTINGS)#Adañir a la escena el Menú de Ajustes

func Quit() -> void:#Función para cerrar el juego al presionar el botón de Exit
	Global.Save()#Guardar Datos
	get_tree().quit(67)#Cerrar el Juego

func Store() -> void:
	var STORE = preload("uid://bxu1dcy688f4c").instantiate()#Instanciar UI de Tienda
	hide()#Ocultar Menú
	add_child(STORE)#Adañir a la escena la tienda
