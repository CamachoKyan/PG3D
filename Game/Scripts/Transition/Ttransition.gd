extends CanvasLayer
#Script Global para UI Transiciones
#Encargado en la transiciones de Juego/Menú

#Variable
@export var AnimS:Node

func _ready() -> void:
	visible = false#Asignar visibilidad desactivada

var tween 
func StartTransition(Game:bool=false) -> void:#Función para crear una animación de transición de escenas
	visible = true#Asignar visibilidad activada
	#Propiedades de la UI transición
	AnimS.scale = Vector2(0,0)
	AnimS.position = Vector2(576,324)
	
	tween  = create_tween()#Crear animación
	#Propiedades de la animación
	tween.tween_property(AnimS,"scale",Vector2(1,1),.75).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)#Asignar animación en paralelo
	tween.tween_property(AnimS,"position",Vector2(0,0),.75).set_trans(Tween.TRANS_CUBIC)
	
	await tween.finished#Esperar fin de la animación
	if Game:#Verificar si la transición es para entrar al juego
		Global.PlayerCanMove = false#Deasctivar flag de movimiento del jugador 
	
	await get_tree().create_timer(.75).timeout#Crear temporizador
	if Game:#Verificar si la transición es para entrar al juego
		Global.RestartGame()#Reiniciar juego
	else:
		#Cambiar escena a Menú
		get_tree().change_scene_to_file("res://Game/Scenes/UI/Menu/Menu.tscn")
		AudioController.InMenu()#Reproducir música del menú
	
	tween  = create_tween()#Crear amimación
	#Propiedades de la animación
	tween.tween_property(AnimS,"scale",Vector2(0,0),.75).set_trans(Tween.TRANS_CIRC)
	tween.set_parallel(true)#Asignar animación en paralelo
	tween.tween_property(AnimS,"position",Vector2(576,324),.75).set_trans(Tween.TRANS_CIRC)
	
	await tween.finished#Esperar fin de la animación
	
	if Game:#Verificar si la transición es para entrar al juego
		AudioController.Playing()#Reproducir música del Juego
		Global.PlayerCanMove = true
	visible = false
