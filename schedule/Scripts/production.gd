extends Control

func _process(delta: float) -> void:
	check_unlocks()

@onready var lock_purple: TextureRect = $Lock_Purple
@onready var lock_meth: TextureRect = $Lock_Meth
@onready var lock_coke: TextureRect = $Lock_Coke
@onready var purpleB: Button = $Purple
@onready var methB: Button = $Meth
@onready var cokeB: Button = $Cocaine

func check_unlocks():
	match Global.purple_unlock:
		false:
			lock_purple.show()
			purpleB.disabled = true
		true:
			lock_purple.hide()
			purpleB.disabled = false
	match Global.meth_unlock:
			false:
				lock_meth.show()
				methB.disabled = true
			true:
				lock_meth.hide()
				methB.disabled = false
	match Global.coke_unlock:
			false:
				lock_coke.show()
				cokeB.disabled = true
			true:
				lock_coke.hide()
				cokeB.disabled = false
