extends Control
#Script para UI Ajustes
func Back() -> void:#Función para salir de la escena Ajustes al presionar el botón Back 
	get_parent().show()
	queue_free()
