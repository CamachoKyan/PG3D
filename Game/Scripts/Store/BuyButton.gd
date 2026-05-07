extends Button
#Script de lógica para los botones de la tienda para realizar compras

#Variables para Asignar valores dinamicos
var TheObj
var Store:Dictionary={
	Skins="ActualSkin",
	Tiles="ActualTile"}
var Type
var Item

func _ready() -> void:
	#Asigbar Valores Dinamicos a partir de los nodos padre
	Type=get_parent().get_parent().get_parent().name
	Item=get_parent().get_parent().name
	
	TheObj = Global.GameData[Type][Item]#Asignar Objeto dinamicamente
	if TheObj.buyed and Item != Global.GameData[Store[Type]]:#Verificar si la Skin esta comprada
			text = "Seleccionar"#Mostrar UI del botón
	elif TheObj.buyed and Item==Global.GameData[Store[Type]]:#Verificar si la Skin esta seleccionada
		text = "Seleccionado"#Mostrar UI del botón 
	else:#Mostrar precio de la skin
		text = "$"+str(TheObj.price)#Mostrar UI del botón 

func _process(_delta: float) -> void:#Función activa todo el tiempo encargada de los procesos del script
	if TheObj.buyed and Item != Global.GameData[Store[Type]]:#Verificar si la Skin esta comprada
		text = "Seleccionar"#Mostrar UI del botón

func Pressed() -> void:#Función para detectar compra o cambio de skins
	if TheObj.buyed and Item!=Global.GameData[Store[Type]]:#Verificar si la Skin esta seleccionada y comprada
		text = "Seleccionado"#Mostrar UI del botón 
		Global.GameData[Store[Type]] = Item#Seleccionar skin
	elif !TheObj.buyed and Global.GameData.Coins>=TheObj.price:#Comprar skin y seleccionarla
			TheObj.buyed = true#Comprar skin
			Global.GameData.Coins-=TheObj.price#Descontar monedas tras compra
			Global.GameData[Store[Type]] = Item#Seleccionar skin
			text = "Seleccionado"#Mostrar UI del botón 
	
	Global.Save()#Guardar Datos
