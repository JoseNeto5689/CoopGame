extends Node2D


@onready var path := $Path2D
@onready var dialog := $Path2D/Boss/Label
@onready var sprite := $Path2D/Boss/Sprite2D

@export var walking_time := 0
@export var text_speed := 0.0

signal text_finished
signal concluded

	
func change_distance(value: Vector2):
	path.curve.set_point_position(1, value)

func slow_write(text: String, delay: float):
	dialog.text = " "
	var new_text = ""
	for character in text.split(""):
		new_text += character
		dialog.text = new_text
		if character != " ":
			await get_tree().create_timer(delay).timeout
	await get_tree().create_timer(4).timeout
	text_finished.emit()


func start():
	sprite.show()
	var tween = create_tween()
	sprite.play("walking")
	await tween.tween_property($Path2D/Boss, "progress_ratio", 0.48, walking_time).finished
	sprite.play("idle")
	slow_write("Bem vindo ao seu novo trabalho", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Irei apresentar a voces a nossa maravilhosa empresa", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Primeiramente", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Voce vai configurar os robos que aparecerem nessa esteira", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("As caracteristicas deles serao especificadas nessa televisao", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Os computadores nas salas abaixo estao programados para adicionar um ponto", text_speed)
	await get_tree().create_timer(text_speed).timeout
	await text_finished
	slow_write("A uma caracteristica especifica", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Quando tiver os pontos exatos, pegue um pendrive no deployer, e coloque no robo", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Sempre que concluir um, sera recompensado", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Caso nao seja possivel concluir", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Aperte o botao vermelho para passar para outro robo", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Agora, me siga", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	tween = create_tween()
	await tween.tween_property($Path2D/Boss, "progress_ratio", 0.6, walking_time).finished
	slow_write("A esquerda esta o computador sobre combate (COM)", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("A direita esta o computador sobre protection (PRO)", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	tween = create_tween()
	await tween.tween_property($Path2D/Boss, "progress_ratio", 0.73, walking_time).finished
	slow_write("A esquerda esta o computador sobre velocity (VEL)", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("A direita esta o computador sobre energy (ENR)", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	tween = create_tween()
	await tween.tween_property($Path2D/Boss, "progress_ratio", 0.86, walking_time).finished
	slow_write("A esquerda esta a sala que voce veio", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("A direita esta o nosso deployer", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Pegue com ele os pendrives para levar aos robos", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	tween = create_tween()
	await tween.tween_property($Path2D/Boss, "progress_ratio", 0.99, walking_time).finished
	slow_write("A direita temos o sr Ze", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Ele apareceu aqui com umas tranqueiras", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Ele vende os pendrives que voce vai precisar", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("E uns negocios a mais", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("A esquerda tem uns computadores quebrados", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Eles eram usados para programar robos mais completos", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Talvez voce precise consertalos", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("O sobrinho do Sr Ze esta ai tambem", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Ele diz que pode melhorar alguns dos seus computadores", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("E isso, boa sorte meu escravo", text_speed)
	await get_tree().create_timer(1).timeout
	await text_finished
	slow_write("Digo... funcionario!", text_speed)
	await text_finished
	dialog.text = ""
	await get_tree().create_timer(1).timeout
	await text_finished
	tween = create_tween()
	await tween.tween_property($Path2D/Boss, "progress_ratio", 0, walking_time).finished
	concluded.emit()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	body.z_index -=1


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.z_index +=1
