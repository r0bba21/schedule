extends Control
@onready var sfx: AudioStreamPlayer2D = $sfx

func soundfx():
	sfx.play()

# SLEEP:
func _on_sleep_pressed() -> void:
	soundfx()
	if Global.sleep_available != false:
		Global.sleep_initiated = true
		Global.sleep_anim = true
		print("Slept!")

# ROOM:
func _on_walls_color_changed(color: Color) -> void:
	Global.room_col = color
	soundfx()

func _on_tv_item_selected(index: int) -> void:
	soundfx()
	match index:
		0:
			Global.tv_off = true
		1:
			Global.tv_off = false

func _on_pots_item_selected(index: int) -> void:
	soundfx()
	match index:
		0:
			Global.pots = false
		1:
			Global.pots = true

# STATS:
@onready var k: Label = $Stats/STATS/K
@onready var pk: Label = $Stats/STATS/PK
@onready var m: Label = $Stats/STATS/M
@onready var c: Label = $Stats/STATS/C
@onready var ts: Label = $Stats/STATS/TS
@onready var tr: Label = $Stats/STATS/TR

func _process(delta: float) -> void:
	k.text = "Kush Sold: " + str(Global.kush_sales)
	pk.text = "Purple Kush Sold: " + str(Global.p_sales)
	m.text = "Meth Sold: " + str(Global.meth_sales)
	c.text = "Cocaine Sold: " + str(Global.coke_sales)
	ts.text = "Total Sales: " + str(Global.kush_sales + Global.p_sales + Global.meth_sales + Global.coke_sales)
	tr.text = "Total Cash: $" + str(Global.total_rev)

func _on_c_text_changed(new_text: String) -> void:
	Global.comp_name = new_text
