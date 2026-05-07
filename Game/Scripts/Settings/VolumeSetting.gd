extends HSlider
#Script encargado en el sistema de Audio del Juego
#Encargado en el cambio de datos y guardado del volumen del Audio

#Variables
@export
var bus_name:String

var bus_index:int

func _ready() -> void:
	#Asignar bus de Audio
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)#Señal para conectar cambio del volumen
	
	#Asignar Volumen a partir de los Datos del Usuario
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(Global.GameData.Audio.get(bus_name)))
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))#Asignar valor del volumen en el bus seleccionado 

func _on_value_changed(values:float) -> void:#Función para cambiar el volumen
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(values))#Cambiar valor del Audio del Juego
	Global.GameData.Audio[bus_name] = values#Guardar Valores de volumen de los Audios
	Global.Save()#Guardar Datos del Usuario
