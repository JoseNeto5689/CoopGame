extends Node
class_name RobotStats

var combat: int
var protection: int
var velocity: int
var energy: int

var charisma: int
var chaos: int

func _init(combat_value: int = 0,protection_value: int = 0,velocity_value: int = 0,energy_value: int = 0, charisma_value : int = 0, chaos_value: int = 0) -> void:
	self.chaos = chaos_value
	self.charisma = charisma_value
	self.combat = combat_value
	self.energy = energy_value
	self.protection = protection_value
	self.velocity = velocity_value
