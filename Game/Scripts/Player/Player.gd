extends CharacterBody3D
#Script Principal para controlar al jugador y su lógica

#Variables
const SPEED = 5.0
const JUMP_VELOCITY = 5
var LastFloor
var ActualFloor
var ActualRing
var LastRing

@export var Detector:CollisionShape3D
@export var EDGY = .075

func _ready() -> void:
	#Asignar Skin dell jugador a partir del Archivo de Datos
	var SkinT = "res://Game/Assets/Player/Skins/"+str(Global.GameData.ActualSkin)+".glb"
	#Añadir y asignar modelo del jugador y sus propiedades
	var Skins = load(SkinT).instantiate()
	Skins.scale=Vector3(.2,.2,.2)
	Skins.position.y=-1
	Skins.rotation_degrees.y=-180
	add_child(Skins)#Añadir skin al jugador
	
	Detector.disabled = true#Desactivar Area de detección del suelo
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED#Cambiar vista del mouse a capturado

func _input(event: InputEvent) -> void:#Función para detectar entradas Teclado/Mouse
	
	#Detectar movimiento de dirección del jugador
	if event is InputEventMouseMotion and Global.PlayerCanMove and !Global.GameOver and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		rotate_y(deg_to_rad(-event.relative.x * EDGY))#Movimiento horizontal de la dirección del jugador

func _physics_process(delta: float) -> void:#Función activa todo el tiempo encargada de los procesos físicos del script
	#Detectar variables Globales para que el jugador pueda moverse
	if !Global.GameOver and !Global.Paused and Engine.time_scale == 1 and Global.PlayerCanMove:
		if not is_on_floor():#Detectar si el jugador esta saltando para aplicar gravedad
			velocity += get_gravity() * delta#Aplicar gravedad
		
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():#Detectar botón de salto mientras el jugador esta en el suelo
			velocity.y = JUMP_VELOCITY#Hacer que el jugador salte
			AudioController.Chicken.play()#Reproducir sonido del jugador
		
		if is_on_floor():#Detectar si el jugador esta en el suelo para activar Area de detección del suelo
			if Detector.disabled==true:
				Detector.disabled = false#Activar Area de detección del suelo
		
		var input_dir := Input.get_vector("Left", "Right", "Up", "Down")#Manejar movimiento del jugador
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()#Manejar dirección a la que avanza el jugador
		if direction:#Detectar dirección
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:#Detener movimiento del jugador
			velocity.x = 0
			velocity.z = 0
			
		move_and_slide()#Función para mover al jugador

func FloorDetectorEntered(body: Node3D) -> void:#Area de detección del suelo
	ActualFloor = body#Asignar suelo
	
	#Verificar que el suelo sea un pilar 
	if body is CharacterBody3D and is_on_floor() and ActualFloor!=LastFloor and body.GameTile:
		ActualRing = body.get_parent().RingN #Asignar anillo en el que se encuentra
		
		var rant=randi_range(1,4)#Aleatoriedad para decidir si el anillo gira
		if !rant==4:
			body.get_parent().Spin = false#Desactivar giro
		
		if ActualRing >= Global.Score:#Cambiar Valor de puntuación
			Global.Score=ActualRing
		
		#Verificar si el jugador cambio de anillo
		if ActualRing != LastRing and LastFloor.GameTile:
			Global.Score = ActualRing#Asignar puntuación
			
			for Rings in Global.RingsList.size():#Iniciar bucle para añadir traslación de los anillos 
				for Floor in Global.RingsList[Rings].get_children():#Iniciar bucle para añadir traslación de los pilares 
					Floor.Shrink(Rings,atan2(Floor.position.x,Floor.position.z))#Función para encoger la posición del anillo y los pilares
				
				Global.RingsList[Rings].Ring -=1#Cambiar id de los anillos
				Global.RingsList[Rings].name = "Ring #"+str(Global.RingsList[Rings].Ring)#Cambiar nombre a los anillos
			
			Global.Spawner.AddRing()#Generar nuevo anillo

func FloorDetectorExited(_body: Node3D) -> void:#Area de detección de salida del suelo
	LastRing = ActualRing#Cambiar anillo anterior
	LastFloor = ActualFloor#Cambiar ultimo suelo
	Detector.disabled=true#Desactivar Area de detección

func GameOverDetector(body: Node3D) -> void:#Función para detectar Game Over
	#Verificar colisión del jugador con el Area de detección de la caida del jugador de los pilares
	if body.name == "Player":
		Global.TheTimer.paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Detector.disabled=true
		Global.GameOver=true
		Global.Save()
		
		var tween = create_tween() #Crear animación
		#Asignar propiedades de la animación
		tween.tween_property(body,"position",Vector3(position.x,position.y-30,position.z),2).set_ease(Tween.EASE_IN)
		tween.set_parallel(true)#Activar animaciones en paralelo
		tween.tween_property(body,"scale",Vector3.ZERO,2).set_ease(Tween.EASE_IN)
		
		await tween.finished#Esperar la finalización de las animaciones
		body.queue_free()#Eliminar escena del jugador
