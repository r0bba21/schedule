extends Control

func _process(delta: float) -> void:
	check_unlocks()
	stocks_ui()
	moneyL.text = "Bank: $" + suffix(money)

@onready var lock_purple: TextureRect = $Lock_Purple
@onready var lock_meth: TextureRect = $Lock_Meth
@onready var lock_coke: TextureRect = $Lock_Coke
@onready var purpleB: Button = $Purple
@onready var methB: Button = $Meth
@onready var cokeB: Button = $Cocaine
@onready var clock: Label = $Time/Clock
@onready var dayL: Label = $Time/Day
# STOCK PANEL LABELS: 1 = GREEN, 2 = PURPLE, 3 = METH, 4 = COKE:
@onready var seed: Label = $Stock/seed
@onready var seed_2: Label = $Stock/seed2
@onready var seed_3: Label = $Stock/seed3
@onready var seed_4: Label = $Stock/seed4
@onready var unfinish: Label = $Stock/unfinish
@onready var unfinish_2: Label = $Stock/unfinish2
@onready var unfinish_3: Label = $Stock/unfinish3
@onready var unfinish_4: Label = $Stock/unfinish4
@onready var finish: Label = $Stock/finish
@onready var finish_2: Label = $Stock/finish2
@onready var finish_3: Label = $Stock/finish3
@onready var finish_4: Label = $Stock/finish4
@onready var packed: Label = $Stock/packed
@onready var packed_2: Label = $Stock/packed2
@onready var packed_3: Label = $Stock/packed3
@onready var packed_4: Label = $Stock/packed4

func check_unlocks():
	match Global.purple_unlock:
		false:
			lock_purple.show()
			purpleB.disabled = true
			seed_2.hide()
			unfinish_2.hide()
			finish_2.hide()
			packed_2.hide()
		true:
			lock_purple.hide()
			purpleB.disabled = false
			seed_2.show()
			unfinish_2.show()
			finish_2.show()
			packed_2.show()
	match Global.meth_unlock:
		false:
			lock_meth.show()
			methB.disabled = true
			seed_3.hide()
			unfinish_3.hide()
			finish_3.hide()
			packed_3.hide()
		true:
			lock_meth.hide()
			methB.disabled = false
			seed_3.show()
			unfinish_3.show()
			finish_3.show()
			packed_3.show()
	match Global.coke_unlock:
		false:
			lock_coke.show()
			cokeB.disabled = true
			seed_4.hide()
			unfinish_4.hide()
			finish_4.hide()
			packed_4.hide()
		true:
			lock_coke.hide()
			cokeB.disabled = false
			seed_4.show()
			unfinish_4.show()
			finish_4.show()
			packed_4.show()

func stocks_ui(): # ONLY HAS GREEN ATM
	seed.text = "Kush Seeds: " + str(green_seeds)
	unfinish.text = "Kush: " + str(green_unfinished)
	finish.text = "Kush: " + str(green_unpackaged)
	packed.text = "Kush: " + str(green_packaged)

@onready var kush_manage: Panel = $Kush_Manage
@onready var sale_menu: Panel = $Sale_Menu

func exit_ui(): # Every panel shares
	soundfx()
	kush_manage.hide()
	sale_menu.hide()

func suffix(input: float):
	var formatted_value:float
	var suffix:String
	if input >= 1000000000:  # B
		formatted_value = round(input / 1000000000.0 * 10) / 10.0
		suffix = "B"
	elif input >= 1000000:  # M
		formatted_value = round(input / 1000000.0 * 10) / 10.0
		suffix = "M"
	elif input >= 1000:  # K
		formatted_value = round(input / 1000.0 * 10) / 10.0
		suffix = "k"
	else: # UNDER 1K:
		formatted_value = input
		suffix = ""
	var formatted:String = str(formatted_value) + suffix
	return formatted

func soundfx(): # ADD
	pass

# FUNDAMENTALS:
@onready var moneyL: Label = $Stock/MONEY
@export var money:int = randi_range(125, 175)

# TIME:
var minutes_as_int:int = 0
var hours_as_int:int = 12
var days:int = 1

func minute():
	var minutes:String
	var hours:String
	minutes_as_int += 1
	if minutes_as_int >= 60:
		minutes_as_int = 0
		hours_as_int += 1
	elif minutes_as_int < 10:
		minutes = "0" + str(minutes_as_int)
	else:
		minutes = str(minutes_as_int)
	if minutes_as_int == 0:
			minutes = "00"
	if hours_as_int >= 25:
		hours_as_int = 0
		day()
		hours = "00"
	else:
		hours = str(hours_as_int)
	clock.text = hours + ":" + minutes
	dayL.text = "Day " + str(days) + ":"

func day(): # Add like bills or income here
	days += 1
	sold_today = 0

# KUSH:
var green_seeds:int = 10
var green_unfinished:int = 0
@export var green_yield:int = 6 # TEMPORARY: 1 seed = 6 unfinished
@export var green_grow_time:int = 40 # TEMPORARY: 1 yield = 40 secs
var green_unpackaged:int = 0
var green_packaged:int = 0
var pots:int = 4 # SHARE THESE WITH PURPLE
var pots_inuse:int = 0 # SHARE THESE WITH PURPLE
var green_demand:int = 25
var green_action_amount:int = 1
@export var green_seed_price:int = 84
@export var green_sale_price:int = 27
var pot_price_VAR:int = 40 # SHOULD = POTS * 10

func pressed_plant_green():
	soundfx()
	for i in range(green_action_amount):
		plant_green()
		refresh_green_ui()

func plant_green():
	if pots_inuse < pots and green_seeds > 0:
		pots_inuse += 1
		green_unfinished += green_yield
		green_seeds -= 1
		var green_planted = Timer.new()
		green_planted.name = "green_planted_%s" % pots_inuse
		green_planted.wait_time = green_grow_time
		green_planted.one_shot = true
		add_child(green_planted)
		green_planted.timeout.connect(green_grown.bind(green_planted))
		green_planted.start()
		print("Planted green")
	else:
		print("All pots are in use or no seeds are available")

func green_grown(green_planted):
	print("Grew green")
	green_planted.queue_free()
	green_unfinished -= green_yield
	green_unpackaged += green_yield
	pots_inuse -= 1

var green_operation:int = 1
var baggies:int = 6
var jars:int = 0
var brick_unlocked:bool = false

func package_green():
	var amount_packaged:int = green_action_amount
	match green_operation:
		1:
			if baggies >= green_action_amount and amount_packaged <= green_unpackaged:
				baggies -= amount_packaged
				green_packaged += amount_packaged
				green_unpackaged -= amount_packaged
		2:
			if jars > green_action_amount and (amount_packaged * 5) <= green_unpackaged:
				jars -= amount_packaged
				green_packaged += (amount_packaged * 5)
				green_unpackaged -= (amount_packaged * 5)
		3:
			if brick_unlocked != false and (amount_packaged * 20) <= green_unpackaged:
				jars -= amount_packaged
				green_packaged += (amount_packaged * 20)
				green_unpackaged -= (amount_packaged * 20)

@onready var pots_av: Label = $Kush_Manage/Info/pots_av
@onready var bags_av: Label = $Kush_Manage/Info/bags_av
@onready var jars_av: Label = $Kush_Manage/Info/jars_av
@onready var bricks_av: Label = $Kush_Manage/Info/bricks_av
@onready var demand_green: Label = $Kush_Manage/Info/demand_green
@onready var seed_green_price: Label = $Kush_Manage/Info/seed_green_price
@onready var pot_price: Label = $Kush_Manage/Info/pot_price

func refresh_green_ui():
	pots_av.text = "Pots Available: " + str(pots - pots_inuse)
	bags_av.text = "Baggies: " + str(baggies)
	jars_av.text = "Jars: " + str(jars)
	match brick_unlocked:
		true:
			bricks_av.text = "Bricks Available"
		false:
			bricks_av.text = "Bricks: LOCKED"
	demand_green.text = "Demand: ~" + str(green_demand)
	seed_green_price.text = "Seed Price: $" + str(green_seed_price)
	pot_price_VAR = (pots * 10)
	pot_price.text = "Pot Price: $" + str(pot_price_VAR)

func _on_kush_pressed() -> void:
	soundfx()
	kush_manage.show()
	refresh_green_ui()

func _on_green_input_text_changed(new_text) -> void:
	soundfx()
	green_action_amount = int(new_text)
	refresh_green_ui()

func _on_buy_seeds_pressed() -> void:
	if money >= (green_seed_price * green_action_amount):
		soundfx()
		money -= (green_seed_price * green_action_amount)
		green_seeds += green_action_amount
		refresh_green_ui()
	else:
		print("Insufficient funds")

func _on_buy_pots_pressed() -> void:
	for i in range(green_action_amount):
		pot_price_VAR = (pots * 10)
		if money >= pot_price_VAR:
			soundfx()
			pots += 1
			money -= pot_price_VAR
			refresh_green_ui()
		else:
			print("Insufficient funds")

func _on_package_choice_green_item_selected(index: int) -> void:
	soundfx()
	green_operation = (index + 1)
	refresh_green_ui()

# SELLING - Range 0-29
var names:Array[String] = ["Robert", "Riley", "Willis", "Jason", "Magnus", "Liam", "Killian", "Abhay", "Kayley", "Joel", "Koby", "Sohan", "Arabella", "Millie", "Beau", "Alex", "Mason", "Kai", "Piyush", "Big Savage", "Jess", "Luca", "Shubh", "Jordan", "Jayden", "Finn", "Miller", "Gabby", "Jack", "Trinity"] 
var names_pure:Array[String] = ["Robert", "Riley", "Willis", "Jason", "Magnus", "Liam", "Killian", "Abhay", "Kayley", "Joel", "Koby", "Sohan", "Arabella", "Millie", "Beau", "Alex", "Mason", "Kai", "Piyush", "Big Savage", "Jess", "Luca", "Shubh", "Jordan", "Jayden", "Finn", "Miller", "Gabby", "Jack", "Trinity"]

func _ready() -> void: # Names test
	print(names[randi_range(0,29)])
	print(names[randi_range(0,29)])
	print(names[randi_range(0,29)])
	var removal = randi_range(0,29)
	print("Removed: "+ names[removal])
	names.remove_at(removal)
	names.append(names_pure[removal])
	print("Appended: " + names[29])
	green_demanded()
	green_demanded()
	green_demanded()

func _on_sale_pressed() -> void:
	soundfx()
	sale_menu.show()

@onready var demand: VBoxContainer = $Sale_Menu/Demand
var sold_today:int

func green_demanded(): # Called by timeout of a sale timer that is dependant on demand so that the player can sell a max of (demand) joints per day
	if sold_today < green_demand:
		var button:Button = Button.new()
		var name_picked:int = randi_range(0,29)
		var product_demanded:int
		var demanded:int
		var price:int
		demanded = randi_range(1,(green_demand - sold_today))
		sold_today += demanded
		price = demanded * green_sale_price * randf_range(0.85,1.15)
		button.text = names[name_picked] + ": " + str(demanded) + "x Kush for $" + str(price)
		demand.add_child(button)
