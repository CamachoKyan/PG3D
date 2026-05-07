extends Node3D
#Script para que las monedas detecten al jugador

func CoinDetector(body: Node3D) -> void:
	if body is CharacterBody3D and body.name == "Player":
		#Detectar al jugador y sumar 1 moneda
		Global.GameData.Coins+=int(1)#Guardar Moneda
		AudioController.Coins()#Reproducir sonido de moneda
		queue_free()#Elimar la moneda
