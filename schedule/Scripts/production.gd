extends Control

func _process(delta: float) -> void:
	check_unlocks()
	stocks_ui()
	moneyL.text = "Bank: $" + _suffix(money)
	lvl_prog.max_value = lvl_xp_cap
	lvl_prog.value = player_xp
	if player_xp >= lvl_xp_cap:
		lvlup()

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
@onready var delivery_menu: Panel = $Delivery_Menu
@onready var research_menu: Panel = $Research_Menu

func exit_ui(): # Every panel shares
	soundfx()
	kush_manage.hide()
	sale_menu.hide()
	delivery_menu.hide()
	research_menu.hide()

func _suffix(input: float):
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
	green_demand = randi_range(20,40)

# KUSH:
var lower_green:int = 30
var upper_green:int = 50
var green_seeds:int = 10
var green_unfinished:int = 0
@export var green_yield:int = 6 # TEMPORARY: 1 seed = 6 unfinished
var green_grow_time:int = randi_range(lower_green,upper_green) # TEMPORARY: 1 yield = 30-50 secs
var green_unpackaged:int = 0
var green_packaged:int = 0
var pots:int = 4 # SHARE THESE WITH PURPLE
var pots_inuse:int = 0 # SHARE THESE WITH PURPLE
@export var green_demand:int = randi_range(20,40)
var green_action_amount:int = 1
@export var green_seed_price:int = 84
@export var green_sale_price:int = 27
@onready var green_info: VBoxContainer = $Kush_Manage/Info

func pressed_plant_green(): # Repeater
	soundfx()
	for i in range(green_action_amount):
		green_grow_time = randi_range(lower_green,upper_green)
		plant_green()
		refresh_green_ui()

func plant_green(): # Actual function
	if pots_inuse < pots and green_seeds > 0:
		pots_inuse += 1
		green_unfinished += green_yield
		green_seeds -= 1
		var green_planted:Timer = Timer.new()
		green_planted.name = "green_planted_%s" % pots_inuse
		green_planted.wait_time = 1
		var wait_time_stored:int = green_grow_time
		var plant_data = {"planttime": 1}
		green_planted.one_shot = false
		add_child(green_planted)
		var pbar:ProgressBar = ProgressBar.new()
		pbar.show_percentage = true
		pbar.max_value = wait_time_stored + 1
		pbar.min_value = 0
		pbar.value = 1
		pbar.theme = load("res://UI/sale.tres") as Theme
		green_info.add_child(pbar)
		green_planted.timeout.connect(green_grown.bind(green_planted, pbar, wait_time_stored, plant_data))
		green_planted.start()
		print("Planted green")
	else:
		print("All pots are in use or no seeds are available")

func green_grown(green_planted: Timer, pbar: ProgressBar, wait_time_stored: int, plant_data):
	plant_data["planttime"] += 1
	pbar.value = plant_data["planttime"]
	if plant_data["planttime"] >= (wait_time_stored + 1):
		print("Grew green")
		green_unfinished -= green_yield
		green_unpackaged += green_yield
		pots_inuse -= 1
		pbar.queue_free()
		green_planted.queue_free()

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
@onready var exposition: Label = $Kush_Manage/Exposition

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
	exposition.text = "Grow your green kush here, each seed takes " +  str(lower_green) + "-" + str(upper_green) + " minutes to grow and yields " + str(green_yield) + " unpackaged kush."

func _on_kush_pressed() -> void:
	soundfx()
	kush_manage.show()
	refresh_green_ui()

func _on_green_input_text_changed(new_text) -> void:
	soundfx()
	green_action_amount = int(new_text)
	refresh_green_ui()

func _on_package_choice_green_item_selected(index: int) -> void:
	soundfx()
	green_operation = (index + 1)
	refresh_green_ui()

# SELLING GREEN:
var names:Array[String] = ["Robert", "Riley", "Willis", "Jason", "Magnus", "Liam", "Killian", "Abhay", "Kayley", "Joel", "Koby", "Sohan", "Arabella", "Millie", "Beau", "Alex", "Mason", "Kai", "Piyush", "Big Savage", "Jess", "Luca", "Shubh", "Jordan", "Jayden", "Finn", "Gabby", "Jack", "Madi"] 

func _on_sale_pressed() -> void: # Menu opener
	soundfx()
	sale_menu.show()

@onready var demand: VBoxContainer = $Sale_Menu/Demand
@onready var sales: VBoxContainer = $Sale_Menu/Sales
var sold_today:int

func green_demanded():
	if sold_today < green_demand:
		var button:Button = Button.new()
		var name_picked:int = randi_range(0, names.size() - 1)
		var min_request:int = randi_range(3,6)
		var max_request:int = min(min_request, (green_demand - sold_today)) # Should probably make the 6 part scale
		var demanded:int = randi_range(1, max_request)
		var raw_price:float = demanded * green_sale_price * randf_range(0.85, 1.15)
		var price:int = round(raw_price)
		button.text = "%s: %dx Kush for $%d" % [names[name_picked], demanded, price]
		button.theme = load("res://UI/sale.tres") as Theme
		button.pressed.connect(green_sale_pressed.bind(demanded, price, button, name_picked)) # CONNECTION
		demand.add_child(button)
	else:
		print("Spawn avoided: exceeded demand")
	green_timer_refresh()

var sales_active:int = 0
var max_sales:int = 4 # Should scale as player gets more dealers

func green_sale_pressed(demanded: int, price: int, button: Button, name_picked: int) -> void:
	soundfx()
	if green_packaged >= demanded and sales_active < max_sales:
		green_packaged -= demanded
		sales_active += 1
		button.disabled = true
		button.text = "Delivering..."
		var sale_time:int = randi_range(10,20) # Should also scale
		var label:Label = Label.new()
		label.text = names[name_picked] + ": " + str(demanded) + "x Kush"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.theme = load("res://UI/sale.tres") as Theme
		sales.add_child(label)
		var bar:ProgressBar = ProgressBar.new()
		bar.max_value = sale_time
		bar.min_value = 0
		bar.value = 0
		bar.show_percentage = true
		bar.theme = load("res://UI/sale.tres") as Theme
		sales.add_child(bar)
		var timer:Timer = Timer.new()
		timer.wait_time = 1
		timer.one_shot = false
		self.add_child(timer)
		var sale_data = {"time_done": 0}
		timer.timeout.connect(_on_sale_timer_timeout.bind(demanded, price, button, timer, sale_time, sale_data, label, bar))
		timer.start()
		names.shuffle()
		player_xp += demanded
	else:
		print("Insufficient kush or no demand or too many active sales")
		button.queue_free()

func _on_sale_timer_timeout(demanded: int, price: int, button: Button, timer: Timer, sale_time: int, sale_data: Dictionary, label: Label, bar: ProgressBar) -> void:
	sale_data["time_done"] += 1
	bar.value = sale_data["time_done"]
	if sale_data["time_done"] >= sale_time:
		money += price
		sold_today += demanded
		button.queue_free()
		timer.queue_free()
		label.queue_free()
		bar.queue_free()
		sales_active -= 1
		print("Sale complete: Green")

@onready var green_demand_Timer: Timer = $Timers/Green_Demand

func green_timer_refresh(): # Timer is one-shot so this will change length (randomise) and then loop
	var low:int = randi_range(25,35)
	var high:int = randi_range(35,45)
	# Make high and low scale later as player progresses
	green_demand_Timer.wait_time = randi_range(low,high)
	green_demand_Timer.start()

# DELIVERIES: - Missing coke and meth
func open_deliveries():
	soundfx()
	delivery_menu.show()

var DLV_actions:int = 1
var cart:Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var items:int = 0
var sum:int = 0

func _on_buy_seeds_pressed() -> void: # GREEN SEEDS - CART 0
	if money >= (green_seed_price * DLV_actions) + sum:
		soundfx()
		cart[0] += DLV_actions
		sum += (green_seed_price * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func _on_buy_pots_pressed() -> void: # CART 1
	if money >= (80 * DLV_actions) + sum:
		soundfx()
		cart[1] += DLV_actions
		sum +=( 80 * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_purp_seeds(): # CART 2
	if money >= (purp_seed_price * DLV_actions) + sum:
		soundfx()
		cart[2] += DLV_actions
		sum += (purp_seed_price * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_fertiliser(): # CART 3
	if money >= (120 * DLV_actions) + sum:
		soundfx()
		cart[3] += DLV_actions
		sum += (120 * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_baggies(): # CART 4
	if money >= (2 * DLV_actions) + sum:
		soundfx()
		cart[4] += DLV_actions
		sum += (2 * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_jars(): # CART 5
	if money >= (8 * DLV_actions) + sum:
		soundfx()
		cart[5] += DLV_actions
		sum += (8 * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

@onready var dispatch: Button = $Delivery_Menu/DISPATCH
@onready var delivery_prog: ProgressBar = $Delivery_Menu/DeliveryProg
var dlv_time:int = 0
var dlv_in_prog:bool = false

func refresh_dispatch():
	items = 0
	for num in cart:
		items += num
	dispatch.text = "Dispatch - " + str(items) + " Items - $" + str(sum + 50)

func DISPATCH():
	soundfx()
	refresh_dispatch()
	if dlv_in_prog != true:
		if money >= sum + 50:
			dlv_time = min((items * 2), 120) # Capped at 2 (ingame) hours
			var timer:Timer = Timer.new()
			timer.wait_time = 1
			delivery_prog.max_value = dlv_time
			delivery_prog.value = 0
			timer.timeout.connect(on_dlv_timeout.bind(timer))
			timer.one_shot = false
			self.add_child(timer)
			timer.start()
			money -= (sum + 50)
			dlv_in_prog = true
			player_xp += (sum / 2)
		else:
			sum = 0
			items = 0
			cart = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			print("Insufficient funds, resetting cart")
			refresh_dispatch()
	else:
		print("Delivery in progress already")

func on_dlv_timeout(timer: Timer):
	delivery_prog.value += 1
	if delivery_prog.value >= dlv_time:
		timer.queue_free()
		dlv_in_prog = false
		dlv_time = 0
		delivery_prog.value = 0
		items = 0
		sum = 0
		green_seeds += cart[0]
		pots += cart[1]
		purp_seeds += cart[2]
		fertiliser += cart[3]
		baggies += cart[4]
		jars += cart[5]
		cart = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		refresh_dispatch()

func DLV_input(text) -> void:
	soundfx()
	DLV_actions = int(text)
	if DLV_actions == null:
		DLV_actions = 1

# RESEARCH:
func open_research():
	soundfx()
	research_menu.show()

var player_lvl:int = 1 # 8 levels
var player_xp:int = 0 # Currently from ordering deliveries and selling products
var lvl_xp_cap:int = 400 # IN PROCESS FUNCTION
@onready var lvl_prog: ProgressBar = $Research_Menu/LVL_prog # IN PROCESS FUNCTION
@onready var lvl_shower: Label = $Research_Menu/LVL_Shower

func lvlup():
	player_xp = 0
	player_lvl += 1
	lvl_shower.text = "YOUR LEVEL: " + str(player_lvl)
	lvl_checker()

func lvl_checker(): # Separated so loadgame functions can use
	match player_lvl:
		1:
			pass
		2: # Unlock lab upgrades
			lvl_xp_cap = 850
		3: # Unlock purple
			lvl_xp_cap = 1100
		4: # Unlock dealers
			lvl_xp_cap = 1800
		5: # Unlock meth
			lvl_xp_cap = 2300
		6: # Unlock staff
			lvl_xp_cap = 3200
		7: # Unlock coke
			lvl_xp_cap = 4000
		8: # Unlock bricks - FINAL LVL
			lvl_xp_cap = 500000000

# PURPLE KUSH:
@export var purp_seed_price:int = 116
var purp_seeds:int = 0
var fertiliser:int = 0
