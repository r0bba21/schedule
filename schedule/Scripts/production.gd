extends Control

func _process(delta: float) -> void:
	check_unlocks()
	stocks_ui()
	moneyL.text = "Bank: $" + _suffix(money)
	lvl_prog.max_value = lvl_xp_cap
	lvl_prog.value = player_xp
	if player_xp >= lvl_xp_cap:
		lvlup()
	if awaiting_sales > 0:
		var bell: TextureRect = $Sale/BELL
		bell.show()
	else:
		var bell: TextureRect = $Sale/BELL
		bell.hide()
	match dlv_in_prog:
		false:
			empty.disabled = false
			dispatch.disabled = false
			delivery_prog.hide()
			inprogdlv.hide()
			dlv_prog_two.hide()
		true:
			empty.disabled = true
			dispatch.disabled = true
			delivery_prog.show()
			inprogdlv.show()
			dlv_prog_two.value = delivery_prog.value
			dlv_prog_two.max_value = delivery_prog.max_value
			dlv_prog_two.min_value = delivery_prog.min_value
			dlv_prog_two.show()
	if hours_as_int >= 20 or hours_as_int < 6: # Sleep
		Global.sleep_available = true
		if hours_as_int >= 20:
			Global.sleep_skips_day = true
		else:
			Global.sleep_skips_day = false
	else:
		Global.sleep_available = false
	if Global.sleep_initiated != false:
		Global.sleep_initiated = false
		hours_as_int = 6
		minutes_as_int = 1
		if Global.sleep_skips_day != false:
			day()

@onready var dlv_prog_two: ProgressBar = $Delivery/DLV_prog_two
@onready var inprogdlv: Label = $Delivery_Menu/inprogdlv
@onready var empty: Button = $Delivery_Menu/Empty
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

func stocks_ui():
	seed.text = "Kush Seeds: " + str(green_seeds)
	unfinish.text = "Kush: " + str(green_unfinished)
	finish.text = "Kush: " + str(green_unpackaged)
	packed.text = "Kush: " + str(green_packaged)
	seed_2.text = "Purple K. Seeds: " + str(purp_seeds)
	unfinish_2.text = "Purple Kush: " + str(purp_unfinished)
	finish_2.text = "Purple Kush: " + str(purp_unpackaged)
	packed_2.text = "Purple Kush: " + str(purp_packaged)
	seed_3.text = "Psuedo: " + str(psuedo)
	unfinish_3.text = "Meth: " + str(meth_unfinished)
	finish_3.text = "Meth: " + str(meth_unpackaged)
	packed_3.text = "Meth: " + str(meth_packaged)
	seed_4.text = "Cocoa Leaves: " + str(coke_leaves)
	unfinish_4.text = "Cocaine: " + str(coke_unfinished)
	finish_4.text = "Cocaine: " + str(coke_unpackaged)
	packed_4.text = "Cocaine: " + str(coke_packaged)

@onready var kush_manage: Panel = $Kush_Manage
@onready var sale_menu: Panel = $Sale_Menu
@onready var delivery_menu: Panel = $Delivery_Menu
@onready var research_menu: Panel = $Research_Menu
@onready var meth_manage: Panel = $Meth_Manage
@onready var coke_manage: Panel = $Coke_Manage

func exit_ui(): # Every panel shares
	soundfx(2)
	kush_manage.hide()
	sale_menu.hide()
	delivery_menu.hide()
	research_menu.hide()
	purp_manage.hide()
	meth_manage.hide()
	coke_manage.hide()

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

@onready var cash_sfx: AudioStreamPlayer2D = $Timers/CashSFX
@onready var sfx: AudioStreamPlayer2D = $Timers/SFX
@onready var notif: AudioStreamPlayer2D = $Timers/Notif

func soundfx(input: int):
	match input:
		1: # Ka-Ching
			cash_sfx.play()
		2: # Select
			sfx.play()
		3: # Notification
			notif.play()

@onready var moneyL: Label = $Stock/MONEY
@export var money:int = 200
@export var ks_time:int = 16

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
		minutes = "00"
		hour()
	if minutes_as_int < 10 and minutes_as_int != 0:
		minutes = "0" + str(minutes_as_int)
	if minutes_as_int >= 10 and minutes_as_int < 60:
		minutes = str(minutes_as_int)
	if hours_as_int >= 24:
		hours_as_int = 0
		day()
		hours = "00"
	if hours_as_int == 0:
		hours = "00"
	if hours_as_int >= 10 and hours_as_int < 24:
		hours = str(hours_as_int)
	if hours_as_int < 10 and hours_as_int != 0:
		hours = "0" + str(hours_as_int)
	clock.text = hours + ":" + minutes
	dayL.text = "Day " + str(days) + ":"

func hour(): # Add like random events here
	pass

func day(): # Add like bills or income here
	days += 1
	sold_today = 0
	green_demand = randi_range(g_d_l,g_d_u)
	PURP_demand = randi_range(p_d_l,p_d_u)
	meth_demand = randi_range(m_d_l,m_d_u)
	coke_demand = randi_range(c_d_l,c_d_u)
	sold_today_p = 0
	meth_sold_today = 0
	coke_sold_today = 0

# GREEN KUSH:
var lower_green:int = 30
var upper_green:int = 50
var green_seeds:int = 10
var green_unfinished:int = 0
@export var WEED_yield:int = 6 # TEMPORARY: 1 seed = 6 unfinished
var green_grow_time:float = randi_range(lower_green,upper_green)
var green_unpackaged:int = 0
var green_packaged:int = 0
var pots:int = 4 # SHARE THESE WITH PURPLE
var pots_inuse:int = 0 # SHARE THESE WITH PURPLE
var g_d_u:int = 60
var g_d_l:int = 30
var green_demand:int = randi_range(g_d_l,g_d_u)
var green_action_amount:int = 1
@export var green_seed_price:int = 75
@export var green_sale_price:int = 34
@onready var green_info: VBoxContainer = $Kush_Manage/Info

func pressed_plant_green(): # Repeater
	soundfx(2)
	for i in range(green_action_amount):
		green_grow_time = randi_range(lower_green,upper_green)
		if fertiliser > 0:
			green_grow_time /= randf_range(1.7,2.2)
			fertiliser -= 1
		plant_green()
		refresh_green_ui()

func plant_green(): # Actual function
	if pots_inuse < pots and green_seeds > 0:
		pots_inuse += 1
		green_unfinished += WEED_yield
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
		green_unfinished -= WEED_yield
		green_unpackaged += WEED_yield
		pots_inuse -= 1
		pbar.queue_free()
		green_planted.queue_free()
		refresh_green_ui()

var green_operation:int = 1
var baggies:int = 6
var jars:int = 0
var brick_unlocked:bool = false

func package_green():
	for i in range(green_action_amount):
		match green_operation:
			1:
				if baggies >= 1 and 1 <= green_unpackaged:
					baggies -= 1
					green_packaged += 1
					green_unpackaged -= 1
			2:
				if jars >= 1 and 5 <= green_unpackaged:
					jars -= 1
					green_packaged += 5
					green_unpackaged -= 5
			3:
				if brick_unlocked != false and 20 <= green_unpackaged:
					green_packaged += 20
					green_unpackaged -= 20
		refresh_green_ui()

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
	exposition.text = "Grow your green kush here, each seed takes " +  str(lower_green) + "-" + str(upper_green) + " minutes to grow and yields " + str(WEED_yield) + " unpackaged kush."

func _on_kush_pressed() -> void:
	soundfx(2)
	kush_manage.show()
	refresh_green_ui()

func _on_green_input_text_changed(new_text) -> void:
	soundfx(2)
	green_action_amount = int(new_text)
	refresh_green_ui()

func _on_package_choice_green_item_selected(index: int) -> void:
	soundfx(2)
	green_operation = (index + 1)
	refresh_green_ui()

# SELLING GREEN:
var names:Array[String] = ["Big Robba", "Riley", "Willis", "Jason", "Magnus", "Liam", "Killian", "Abhay", "Kayley", "Joel", "Koby", "Sohan", "Arabella", "Millie", "Beau", "Piyush", "Big Savage", "Vecchio", "Finn", "Gabby", "Madi"] 

func _on_sale_pressed() -> void: # Menu opener
	soundfx(2)
	sale_menu.show()

@onready var demand: VBoxContainer = $Sale_Menu/Demand
@onready var sales: VBoxContainer = $Sale_Menu/Sales
var sold_today:int = 0

func green_demanded():
	soundfx(3)
	var demanded:int
	if sold_today < green_demand:
		var min_max:int = randi_range(4,7)
		var max_request:int = min(min_max, (green_demand - sold_today))
		demanded = randi_range(1, max_request)
	else:
		demanded = randi_range(1,3)
	var button:Button = Button.new()
	var name_picked:int = randi_range(0, names.size() - 1)
	var raw_price:float = demanded * green_sale_price * randf_range(0.9, 1.15)
	var price:int = round(raw_price)
	button.text = "%s: %dx Kush for $%d" % [names[name_picked], demanded, price]
	button.theme = load("res://UI/sale.tres") as Theme
	var kill_switch:Timer = Timer.new()
	kill_switch.wait_time = ks_time
	add_child(kill_switch)
	button.pressed.connect(green_sale_pressed.bind(demanded, price, button, name_picked, kill_switch)) # CONNECTION
	demand.add_child(button)
	green_timer_refresh()
	awaiting_sales += 1
	kill_switch.timeout.connect(sale_missed_G.bind(button, kill_switch))
	kill_switch.start()

func sale_missed_G(button: Button, kill_switch: Timer):
	print("Took too long!")
	button.queue_free()
	kill_switch.queue_free()
	awaiting_sales -= 1

var sales_active:int = 0
var max_sales:int = 4

func green_sale_pressed(demanded: int, price: int, button: Button, name_picked: int, kill_switch: Timer) -> void:
	soundfx(2)
	if green_packaged >= demanded and sales_active < max_sales:
		green_packaged -= demanded
		sales_active += 1
		button.disabled = true
		button.text = "Delivering..."
		var sale_time:int = randi_range(demanded * 4,demanded * 8)
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
		awaiting_sales -= 1
		kill_switch.queue_free()
	else:
		print("Insufficient kush or too many active sales")
		soundfx(2)

func _on_sale_timer_timeout(demanded: int, price: int, button: Button, timer: Timer, sale_time: int, sale_data: Dictionary, label: Label, bar: ProgressBar) -> void:
	sale_data["time_done"] += 1
	bar.value = sale_data["time_done"]
	if sale_data["time_done"] >= sale_time:
		money += price
		sold_today += demanded
		player_xp += (demanded * 5)
		button.queue_free()
		timer.queue_free()
		label.queue_free()
		bar.queue_free()
		Global.kush_sales += demanded
		Global.total_rev += price
		soundfx(1)
		sales_active -= 1
		print("Sale complete: Green")

@onready var green_demand_Timer: Timer = $Timers/Green_Demand

func green_timer_refresh(): # Timer is one-shot so this will change length (randomise) and then loop
	var low:int = randi_range(15,30)
	var high:int = randi_range(30,35)
	green_demand_Timer.wait_time = randi_range(low,high)
	if (green_demand - sold_today) > (green_demand * .65):
		green_demand_Timer.wait_time /= 2
	if (green_demand - sold_today) > (green_demand * .5) and (green_demand - sold_today) < (green_demand * .65):
		green_demand_Timer.wait_time /= 1.5
	green_demand_Timer.start()

# DELIVERIES: - Missing coke and meth
func open_deliveries():
	soundfx(2)
	delivery_menu.show()

var DLV_actions:int = 1
var cart:Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var items:int = 0
var sum:int = 0

func _on_buy_seeds_pressed() -> void: # GREEN SEEDS - CART 0
	if money >= (green_seed_price * DLV_actions) + sum:
		soundfx(2)
		cart[0] += DLV_actions
		sum += (green_seed_price * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func _on_buy_pots_pressed() -> void: # CART 1
	if money >= (80 * DLV_actions) + sum:
		soundfx(2)
		cart[1] += DLV_actions
		sum +=( 80 * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_purp_seeds(): # CART 2
	if money >= (purp_seed_price * DLV_actions) + sum:
		soundfx(2)
		cart[2] += DLV_actions
		sum += (purp_seed_price * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_fertiliser(): # CART 3
	if money >= (120 * DLV_actions) + sum:
		soundfx(2)
		cart[3] += DLV_actions
		sum += (120 * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_baggies(): # CART 4
	if money >= (2 * DLV_actions) + sum:
		soundfx(2)
		cart[4] += DLV_actions
		sum += (2 * DLV_actions)
		refresh_dispatch()
	else:
		print("Insufficient funds")

func buy_jars(): # CART 5
	if money >= (8 * DLV_actions) + sum:
		soundfx(2)
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
	dispatch.text = "Dispatch - " + str(items) + " Items - $" + str(sum + 15)

func DISPATCH():
	soundfx(1)
	refresh_dispatch()
	if dlv_in_prog != true:
		if money >= sum + 15:
			dlv_time = min((items * 1.75), 90) # Capped at 90 minutes
			var timer:Timer = Timer.new()
			timer.wait_time = 0.7
			delivery_prog.max_value = dlv_time
			delivery_prog.value = 0
			timer.timeout.connect(on_dlv_timeout.bind(timer))
			timer.one_shot = false
			self.add_child(timer)
			timer.start()
			money -= (sum + 15)
			dlv_in_prog = true
			player_xp += (sum / 3)
		else:
			soundfx(3)
	else:
		print("Delivery in progress already")

func EMPTY():
	sum = 0
	items = 0
	cart = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	refresh_dispatch()
	soundfx(2)

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
		refresh_green_ui()
		refresh_purp_ui()

func DLV_input(text) -> void:
	soundfx(2)
	DLV_actions = int(text)
	if DLV_actions == null:
		DLV_actions = 1

# RESEARCH:
func open_research():
	soundfx(2)
	research_menu.show()

@export var player_lvl:int = 1 # 8 levels
var player_xp:int = 0 # Currently from ordering deliveries and selling products
var lvl_xp_cap:int = 400 # IN PROCESS FUNCTION
var lvl_up_reward:int = 250
var mix_ins_unlock:bool = false # For future reference?
@onready var lvl_prog: ProgressBar = $Research_Menu/LVL_prog # IN PROCESS FUNCTION
@onready var lvl_shower: Label = $Research_Menu/LVL_Shower
@onready var packageUP: Button = $Research_Menu/LVLS/Title/ResearchsL2/Package
@onready var mixUP: Button = $Research_Menu/LVLS/Title/ResearchsL2/Mix
@onready var uvUP: Button = $Research_Menu/LVLS/Title/ResearchsL2/UV
@onready var unlock_p_kushUP: Button = $"Research_Menu/LVLS/Title2/Unlock PKush"
@onready var waltUP: Button = $Research_Menu/LVLS/Title3/ResearchsL4/Walt
@onready var weed_yieldUP: Button = $Research_Menu/LVLS/Title3/ResearchsL4/WeedYield
@onready var chloeUP: Button = $Research_Menu/LVLS/Title3/ResearchsL4/Chloe
@onready var unlock_methUP: Button = $"Research_Menu/LVLS/Title4/Unlock Meth"
@onready var ads_2UP: Button = $Research_Menu/LVLS/Title5/ResearchsL6/Ads2
@onready var weed_staffUP: Button = $Research_Menu/LVLS/Title5/ResearchsL6/WeedStaff
@onready var seed_priceUP: Button = $Research_Menu/LVLS/Title5/ResearchsL6/SeedPrice
@onready var meth_staffUP: Button = $Research_Menu/LVLS/Title5/ResearchsL6/MethStaff
@onready var unlock_cokeUP: Button = $"Research_Menu/LVLS/Title6/Unlock Coke"
@onready var bricksUP: Button = $Research_Menu/LVLS/Title7/ResearchsL8/Bricks
@onready var coke_staffUP: Button = $Research_Menu/LVLS/Title7/ResearchsL8/CokeStaff
@onready var yieldUP: Button = $Research_Menu/LVLS/Title7/ResearchsL8/Yield
@onready var adsUP: Button = $Research_Menu/LVLS/Title/ResearchsL2/Ads
@onready var lvlupP: Panel = $LVLUP
@onready var reward_lvl: Label = $LVLUP/Reward_LVL
@onready var new_lvl: Label = $LVLUP/NEW_LVL

func lvlup():
	player_xp = 0
	player_lvl += 1
	lvl_shower.text = "YOUR LEVEL: " + str(player_lvl)
	money += lvl_up_reward
	new_lvl.text = str(player_lvl)
	reward_lvl.text = "Enjoy a reward of $" + str(lvl_up_reward) + "!"
	soundfx(3)
	lvlupP.show()
	lvl_checker()

func lvl_checker(): # Separated so loadgame functions can use
	lvl_shower.text = "YOUR LEVEL: " + str(player_lvl)
	match player_lvl:
		1:
			lvl_xp_cap = 400
			lvl_up_reward = 300
		2: # Unlock lab upgrades
			lvl_xp_cap = 700
			lvl_up_reward = 600
		3: # Unlock purple
			lvl_xp_cap = 1100
			lvl_up_reward = 700
		4: # Unlock dealers
			lvl_xp_cap = 1500
			lvl_up_reward = 1100
		5: # Unlock meth
			lvl_xp_cap = 1900
			lvl_up_reward = 1300
		6: # Unlock staff
			lvl_xp_cap = 2300
			lvl_up_reward = 2000
		7: # Unlock coke
			lvl_xp_cap = 2700
			lvl_up_reward = 2300
		8: # Unlock bricks - FINAL LVL
			lvl_xp_cap = 500000000
			lvl_up_reward = 500000

func exit_lvlup():
	lvlupP.hide()
	soundfx(2)

func package_up():
	if money >= 1000 and player_lvl >= 2:
		green_sale_price += 5
		soundfx(1)
		money -= 1000
		packageUP.disabled = true

func mix_up(): # Future update: Make mix-ins an actual feature in drug growth menu
	if money >= 1000 and player_lvl >= 2:
		mix_ins_unlock = true
		money -= 1000
		soundfx(1)
		green_sale_price += 5
		mixUP.disabled = true

func UV_up():
	if money >= 1000 and player_lvl >= 2:
		lower_green -= 5
		upper_green -= 5
		purp_lower -= 8
		purp_higher -= 8
		money -= 1000
		soundfx(1)
		uvUP.disabled = true

func ads_up():
	if money >= 500 and player_lvl >= 2:
		g_d_l += 5
		g_d_u += 5
		p_d_l += 5
		p_d_u += 5
		money -= 500
		soundfx(1)
		adsUP.disabled = true

func P_unlock():
	if money >= 2500 and player_lvl >= 3:
		Global.purple_unlock = true
		money -= 2500
		soundfx(1)
		unlock_p_kushUP.disabled = true
		purple_demand.start()

func walt_unlock():
	if money >= 5000 and player_lvl >= 4:
		max_sales += 4
		money -= 5000
		soundfx(1)
		waltUP.disabled = true

func weed_UP():
	if money >= 3000 and player_lvl >= 4:
		WEED_yield += 4
		money -= 3000
		soundfx(1)
		weed_yieldUP.disabled = true

func chloe_unlock():
	if money >= 7500 and player_lvl >= 4:
		max_sales += 4
		money -= 7500
		soundfx(1)
		chloeUP.disabled = true

func meth_unlock():
	if money >= 5000 and player_lvl >= 5:
		money -= 5000
		Global.meth_unlock = true
		soundfx(1)
		unlock_methUP.disabled = true
		meth_demandTimer.start()

func ad_up_two(): # Remember to add meth to this later
	if money >= 2000 and player_lvl >= 6:
		g_d_l += 3
		g_d_u += 3
		p_d_l += 5
		p_d_u += 7
		money -= 2000
		soundfx(1)
		ads_2UP.disabled = true

func w_staff():
	if money >= 7500 and player_lvl >= 6:
		Global.weed_staff = true
		money -= 7500
		soundfx(1)
		weed_staffUP.disabled = true

@onready var green_seedsB: Button = $Delivery_Menu/Purchase/GreenSeeds
@onready var purp_seedsB: Button = $Delivery_Menu/Purchase/PurpSeeds

func seed_cheaper():
	if money >= 3000 and player_lvl >= 6:
		money -= 3000
		soundfx(1)
		seed_priceUP.disabled = true
		purp_seed_price -= 30
		green_seed_price -= 30
		green_seedsB.text = "Kush Seeds: $45"
		purp_seedsB.text =" Purple Kush Seeds: $80"

func m_staff():
	if money >= 10000 and player_lvl >= 6:
		Global.meth_staff = true
		money -= 10000
		soundfx(1)
		meth_staffUP.disabled = true

func coke_unlock():
	if money >= 10000 and player_lvl >= 7:
		Global.coke_unlock = true
		soundfx(1)
		money -= 10000
		unlock_cokeUP.disabled = true

func bricks():
	if money >= 2000 and player_lvl >= 8:
		money -= 2000
		brick_unlocked = true
		soundfx(1)
		bricksUP.disabled = true

func c_staff():
	if money >= 15000:
		Global.coke_staff = true
		money -= 15000
		soundfx(1)
		coke_staffUP.disabled = true

func yield_up(): # Remember to add  meth and coke here
	if money >= 10000 and player_lvl >= 8:
		p_d_l += 4
		p_d_u += 4
		g_d_l += 4
		g_d_u += 4
		money -= 10000
		soundfx(1)
		yieldUP.disabled = true

# PURPLE KUSH:
func open_purp():
	soundfx(2)
	refresh_purp_ui()
	purp_manage.show()

@onready var purp_manage: Panel = $Purp_Manage
@export var purp_seed_price:int = 110
@export var purp_seeds:int = 0
var purp_unfinished:int = 0
var purp_unpackaged:int = 0
var purp_packaged:int = 0
var fertiliser:int = 0
var p_d_l:int = 40
var p_d_u:int = 60
var PURP_demand:int = randi_range(p_d_l,p_d_u)
var purp_higher:int = 60
var purp_lower:int = 40
var PURP_wait_time:int = randi_range(purp_lower,purp_higher)
var PURP_input:int = 1
var purp_operation:int = 1 # Packaging
@export var PURP_sale_price:int = 50
@onready var expositionP: Label = $Purp_Manage/Exposition
@onready var pots_avP: Label = $Purp_Manage/Info/pots_av
@onready var bags_avP: Label = $Purp_Manage/Info/bags_av
@onready var jars_avP: Label = $Purp_Manage/Info/jars_av
@onready var bricks_avP: Label = $Purp_Manage/Info/bricks_av
@onready var demand_purpP: Label = $Purp_Manage/Info/demand_purp
@onready var purp_info: VBoxContainer = $Purp_Manage/Info

func refresh_purp_ui():
	expositionP.text = "Grow your purple kush here, each seed takes " + str(purp_lower) + "-" + str(purp_higher) + " minutes to grow and yields + " + str(WEED_yield) + " unpackaged kush."
	pots_avP.text = "Pots Available: " + str(pots - pots_inuse)
	bags_avP.text = "Baggies: " + str(baggies)
	jars_avP.text = "Jars: " + str(jars)
	match brick_unlocked:
		true:
			bricks_avP.text = "Bricks Available"
		false:
			bricks_avP.text = "Bricks: LOCKED"
	demand_purpP.text = "Demand: ~" + str(PURP_demand)

func purp_input(text) -> void:
	PURP_input = int(text)
	soundfx(2)
	refresh_purp_ui()
	if PURP_input == null:
		PURP_input = 1

func _on_package_choice_purp_item_selected(index: int) -> void:
	purp_operation = index + 1
	soundfx(2)
	refresh_purp_ui()

func _on_package_purp_pressed() -> void:
	soundfx(2)
	for i in range(PURP_input):
		match purp_operation:
			1:
				if purp_unpackaged >= 1 and baggies >= 1:
					purp_unpackaged -= 1
					purp_packaged += 1
					baggies -= 1
			2:
				if purp_unpackaged >= 5 and jars >= 1:
					purp_unpackaged -= 5
					purp_packaged += 5
					jars -= 1
			3:
				if purp_unpackaged >= 20 and brick_unlocked != false:
					purp_unpackaged -= 20
					purp_packaged += 20
		refresh_purp_ui()

func purp_pressed_plant(): # Repeater
	soundfx(2)
	for i in range(PURP_input):
		PURP_wait_time = randi_range(purp_lower,purp_higher)
		if fertiliser > 0:
			PURP_wait_time /= randf_range(1.7,2.2)
			fertiliser -= 1
		PURP_plant()
		refresh_purp_ui()

func PURP_plant(): # Actual function
	if pots_inuse < pots and purp_seeds > 0:
		pots_inuse += 1
		purp_unfinished += WEED_yield
		purp_seeds -= 1
		var purp_planted:Timer = Timer.new()
		purp_planted.name = "purple_planted_%s" % pots_inuse
		purp_planted.wait_time = 1
		var wait_time_stored:int = PURP_wait_time
		var plant_data = {"planttime": 1}
		purp_planted.one_shot = false
		add_child(purp_planted)
		var pbar:ProgressBar = ProgressBar.new()
		pbar.show_percentage = true
		pbar.max_value = wait_time_stored + 1
		pbar.min_value = 0
		pbar.value = 1
		pbar.theme = load("res://UI/sale_purp.tres") as Theme
		purp_info.add_child(pbar)
		purp_planted.timeout.connect(PURP_grown.bind(purp_planted, pbar, wait_time_stored, plant_data))
		purp_planted.start()
		print("Planted purple")
	else:
		print("All pots are in use or no seeds are available")

func PURP_grown(purp_planted: Timer, pbar: ProgressBar, wait_time_stored: int, plant_data):
	plant_data["planttime"] += 1
	pbar.value = plant_data["planttime"]
	if plant_data["planttime"] >= (wait_time_stored + 1):
		print("Grew green")
		purp_unfinished -= WEED_yield
		purp_unpackaged += WEED_yield
		pots_inuse -= 1
		pbar.queue_free()
		purp_planted.queue_free()
		refresh_purp_ui()

# SELLING PURPLE:
var sold_today_p:int = 0
@onready var purple_demand: Timer = $Timers/Purple_Demand
var awaiting_sales:int = 0

func purp_timer_refresh():
	var low:int = randi_range(30,40)
	var high:int = randi_range(40,50)
	purple_demand.wait_time = randi_range(low,high)
	if (PURP_demand - sold_today_p) > (PURP_demand * 0.65):
		purple_demand.wait_time /= 2
	if (PURP_demand - sold_today_p) > (PURP_demand * 0.5) and (PURP_demand - sold_today_p) < (PURP_demand * 0.65):
		purple_demand.wait_time /= 1.5
	purple_demand.start()

func purp_demanded():
	soundfx(3)
	var demanded:int
	if sold_today_p < PURP_demand:
		var min_request:int = randi_range(5,8)
		var max_request:int = min(min_request, (PURP_demand - sold_today_p))
		demanded = randi_range(1, max_request)
	else:
		demanded = randi_range(1,3)
	var kill_switch:Timer = Timer.new()
	kill_switch.wait_time = ks_time
	add_child(kill_switch)
	kill_switch.start()
	var button:Button = Button.new()
	var name_picked:int = randi_range(0, names.size() - 1)
	var raw_price:float = demanded * PURP_sale_price * randf_range(0.9, 1.15)
	var price:int = round(raw_price)
	button.text = "%s: %dx Purple Kush for $%d" % [names[name_picked], demanded, price]
	button.theme = load("res://UI/sale_purp.tres") as Theme
	button.pressed.connect(purple_sale_pressed.bind(demanded, price, button, name_picked, kill_switch)) # CONNECTION
	kill_switch.timeout.connect(sale_missed.bind(button, kill_switch))
	demand.add_child(button)
	purp_timer_refresh()
	awaiting_sales += 1

func sale_missed(button: Button, kill_switch: Timer):
	print("Took too long!")
	button.queue_free()
	kill_switch.queue_free()
	awaiting_sales -= 1

func purple_sale_pressed(demanded: int, price: int, button: Button, name_picked: int, kill_switch: Timer) -> void:
	soundfx(2)
	if purp_packaged >= demanded and sales_active < max_sales:
		purp_packaged -= demanded
		sales_active += 1
		button.disabled = true
		button.text = "Delivering..."
		var sale_time:int = randi_range(demanded * 4,demanded * 8)
		var label:Label = Label.new()
		label.text = names[name_picked] + ": " + str(demanded) + "x Purple Kush"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.theme = load("res://UI/sale_purp.tres") as Theme
		sales.add_child(label)
		var bar:ProgressBar = ProgressBar.new()
		bar.max_value = sale_time
		bar.min_value = 0
		bar.value = 0
		bar.show_percentage = true
		bar.theme = load("res://UI/sale_purp.tres") as Theme
		sales.add_child(bar)
		var timer:Timer = Timer.new()
		timer.wait_time = 1
		timer.one_shot = false
		self.add_child(timer)
		var sale_data = {"time_done": 0}
		timer.timeout.connect(_on_purp_timer_timeout.bind(demanded, price, button, timer, sale_time, sale_data, label, bar))
		timer.start()
		sold_today_p += demanded
		awaiting_sales -= 1
		kill_switch.queue_free()
	else:
		print("Insufficient purple kush or too many active sales")
		soundfx(2)

func _on_purp_timer_timeout(demanded: int, price: int, button: Button, timer: Timer, sale_time: int, sale_data: Dictionary, label: Label, bar: ProgressBar) -> void:
	sale_data["time_done"] += 1
	bar.value = sale_data["time_done"]
	if sale_data["time_done"] >= sale_time:
		money += price
		player_xp += (demanded * 8)
		Global.p_sales += demanded
		Global.total_rev += price
		button.queue_free()
		timer.queue_free()
		label.queue_free()
		bar.queue_free()
		soundfx(1)
		sales_active -= 1
		print("Sale complete: Purple")

# METH:
@export var psuedo:int = 0
@export var crystal_price:int = 70
@export var psuedo_price:int = 120
@export var chem_tables:int = 1
var chem_tables_avl:int = 1
var active_meth_batches:int = 0
@export var meth_yield:int = 8
var m_d_l:int = 40
var m_d_u:int = 60
var meth_demand:int = randi_range(m_d_l,m_d_u)
var cook_lower:int = 45
var cook_higher:int = 60
var meth_input:int = 1
var meth_pack_op:int = 1
@onready var chem_avM: Label = $Meth_Manage/Info/chem_av
@onready var bags_avM: Label = $Meth_Manage/Info/bags_av
@onready var jars_avM: Label = $Meth_Manage/Info/jars_av
@onready var bricks_avM: Label = $Meth_Manage/Info/bricks_av
@onready var dmnd_meth: Label = $Meth_Manage/Info/dmnd_METH
@onready var exposition_meth: Label = $Meth_Manage/Exposition_Meth
var meth_unfinished:int = 0
var meth_unpackaged:int = 0
var meth_packaged:int = 0
@onready var meth_info: VBoxContainer = $Meth_Manage/Info

func open_meth():
	meth_manage.show()
	soundfx(2)
	refresh_meth()

func refresh_meth():
	chem_tables_avl = chem_tables - active_meth_batches
	chem_avM.text = "Chem Sets Available: " + str(chem_tables_avl)
	bags_avM.text = "Baggies: " + str(baggies)
	jars_avM.text = "Jars: " + str(jars)
	match brick_unlocked:
		true:
			bricks_avM.text = "Bricks Available"
		false:
			bricks_avM.text = "Bricks: LOCKED"
	dmnd_meth.text = "Demand: ~" + str(meth_demand)
	exposition_meth.text = "Cook your meth here, each batch of " + str(meth_yield) + " crystals takes " + str(cook_lower) + "-" + str(cook_higher) + " minutes to cook and 1 psuedo"

func _on_meth_input_text_changed(new_text) -> void:
	soundfx(2)
	meth_input = int(new_text)
	if meth_input == null:
		meth_input = 1
	refresh_meth()

func _on_packing_meth_pressed() -> void:
	soundfx(2)
	for i in meth_input:
		match meth_pack_op:
			1:
				if baggies >= 1 and meth_unpackaged >= 1:
					meth_unpackaged -= 1
					baggies -= 1
					meth_packaged += 1
			2:
				if jars >= 1 and meth_unpackaged >= 5:
					meth_unpackaged -= 5
					jars -= 1
					meth_packaged += 5
			3:
				if meth_unpackaged >= 20 and brick_unlocked != false:
					meth_unpackaged -= 20
					meth_packaged += 20
	refresh_meth()

func _on_meth_pack_op_pressed(index: int) -> void:
	soundfx(2)
	meth_pack_op = index + 1
	refresh_meth()

func _on_cook_meth_pressed() -> void:
	soundfx(2)
	for i in meth_input:
		chem_tables_avl = chem_tables - active_meth_batches
		if psuedo >= 1 and chem_tables_avl >= 1:
			active_meth_batches += 1
			psuedo -= 1
			meth_unfinished += meth_yield
			var cook_timer:Timer = Timer.new()
			cook_timer.wait_time = 1
			var wait_time_stored:int = randi_range(cook_lower,cook_higher)
			var data = {"cooktime": 1}
			cook_timer.one_shot = false
			add_child(cook_timer)
			var pbar:ProgressBar = ProgressBar.new()
			pbar.show_percentage = true
			pbar.max_value = wait_time_stored + 1
			pbar.min_value = 0
			pbar.value = 1
			pbar.theme = load("res://UI/sale_meth.tres") as Theme
			meth_info.add_child(pbar)
			cook_timer.timeout.connect(cook_over.bind(cook_timer, pbar, wait_time_stored, data))
			cook_timer.start()
			print("Cook started")
			refresh_meth()
	refresh_meth()

func cook_over(cook_timer: Timer, pbar: ProgressBar, wait_time_stored: int, data):
	data["cooktime"] += 1
	pbar.value = data["cooktime"]
	if data["cooktime"] >= (wait_time_stored + 1):
		print("Meth done")
		meth_unfinished -= meth_yield
		meth_unpackaged += meth_yield
		active_meth_batches -= 1
		pbar.queue_free()
		cook_timer.queue_free()
		refresh_meth()

# SELLING METH:
var meth_sold_today:int = 0
@onready var meth_demandTimer: Timer = $Timers/Meth_Demand

func refresh_meth_timer():
	var low:int = randi_range(40,50)
	var high:int = randi_range(50,60)
	meth_demandTimer.wait_time = randi_range(low,high)
	if (meth_demand - meth_sold_today) >= (meth_demand * .65):
		meth_demandTimer.wait_time /= 2
	if (meth_demand - meth_sold_today) >= (meth_demand * .5) and (meth_demand - meth_sold_today) < (meth_demand * .65):
		meth_demandTimer.wait_time /= 1.5
	meth_demandTimer.start()

func meth_demanded() -> void:
	soundfx(3)
	var demanded:int
	if meth_sold_today < meth_demand:
		var min_request:int = randi_range(3,6)
		var max_request:int = min(min_request, (PURP_demand - sold_today_p))
		demanded = randi_range(1, max_request)
	else:
		demanded = randi_range(1,2)
	var kill_switch:Timer = Timer.new()
	kill_switch.wait_time = ks_time
	add_child(kill_switch)
	kill_switch.start()
	var button:Button = Button.new()
	var name_picked:int = randi_range(0, names.size() - 1)
	var raw_price:float = demanded * crystal_price * randf_range(0.9, 1.15)
	var price:int = round(raw_price)
	button.text = "%s: %dx Meth for $%d" % [names[name_picked], demanded, price]
	button.theme = load("res://UI/sale_meth.tres") as Theme
	button.pressed.connect(meth_sale_accepted.bind(demanded, price, button, name_picked, kill_switch)) # CONNECTION
	kill_switch.timeout.connect(sale_missed_meth.bind(button, kill_switch))
	demand.add_child(button)
	purp_timer_refresh()
	awaiting_sales += 1

func sale_missed_meth(button: Button, kill_switch: Timer):
	print("Took too long!")
	button.queue_free()
	kill_switch.queue_free()
	awaiting_sales -= 1

func meth_sale_accepted(demanded: int, price: int, button: Button, name_picked:int, kill_switch: Timer):
	soundfx(2)
	if meth_packaged >= demanded and sales_active < max_sales:
		meth_packaged -= demanded
		sales_active += 1
		button.disabled = true
		button.text = "Delivering..."
		var sale_time:int = randi_range(demanded * 4,demanded * 8)
		var label:Label = Label.new()
		label.text = names[name_picked] + ": " + str(demanded) + "x Meth"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.theme = load("res://UI/sale_meth.tres") as Theme
		sales.add_child(label)
		var bar:ProgressBar = ProgressBar.new()
		bar.max_value = sale_time
		bar.min_value = 0
		bar.value = 0
		bar.show_percentage = true
		bar.theme = load("res://UI/sale_meth.tres") as Theme
		sales.add_child(bar)
		var timer:Timer = Timer.new()
		timer.wait_time = 1
		timer.one_shot = false
		self.add_child(timer)
		var sale_data = {"time_done": 0}
		timer.timeout.connect(meth_sale_complete.bind(demanded, price, button, timer, sale_time, sale_data, label, bar))
		timer.start()
		sold_today_p += demanded
		awaiting_sales -= 1
		kill_switch.queue_free()
	else:
		print("Insufficient meth or too many active sales")
		soundfx(2)

func meth_sale_complete(demanded: int, price: int, button: Button, timer: Timer, sale_time: int, sale_data, label: Label, bar: ProgressBar):
	sale_data["time_done"] += 1
	bar.value = sale_data["time_done"]
	if sale_data["time_done"] >= sale_time:
		money += price
		player_xp += (demanded * 12)
		Global.meth_sales += demanded
		Global.total_rev += price
		button.queue_free()
		timer.queue_free()
		label.queue_free()
		bar.queue_free()
		soundfx(1)
		sales_active -= 1
		print("Sale complete: Meth")

# COCAINE:
@export var leaves_price:int = 150
@export var coke_price:int = 100
@export var cauldrons:int = 1
@export var coke_yield:int = 12
var coke_leaves:int = 0
var coke_unfinished:int = 0
var coke_unpackaged:int = 0
var coke_packaged:int = 0
var c_d_l:int = 30
var c_d_u:int = 60
var coke_demand:int = randi_range(c_d_l,c_d_u)
var coke_input:int = 1
var coke_pack_op:int = 1
var boil_lower:int = 50
var boil_upper:int = 70
var active_cauldrons:int = 0
@onready var cauldron_av: Label = $Coke_Manage/Info/cauldron_av
@onready var bags_avC: Label = $Coke_Manage/Info/bags_av
@onready var jars_avC: Label = $Coke_Manage/Info/jars_av
@onready var bricks_avC: Label = $Coke_Manage/Info/bricks_av
@onready var dmnd_coke: Label = $Coke_Manage/Info/dmnd_COKE
@onready var exposition_coke: Label = $Coke_Manage/Exposition_Coke
@onready var coke_info: VBoxContainer = $Coke_Manage/Info

func open_coke():
	coke_manage.show()
	soundfx(2)
	refresh_coke_ui()

func refresh_coke_ui():
	cauldron_av.text = "Cauldrons Available: " + str(cauldrons - active_cauldrons)
	bags_avC.text = "Baggies: " + str(baggies)
	jars_avC.text = "Jars: " + str(jars)
	match brick_unlocked:
		true:
			bricks_avC.text = "Bricks Available"
		false:
			bricks_avC.text = "Bricks: LOCKED"
	dmnd_coke.text = "Demand: ~" + str(coke_demand)
	exposition_coke.text = "Cook your cocaine here, each pot takes " + str(boil_lower) + "-" + str(boil_upper) + " minutes to cook and yields " + str(coke_yield) + " lines."

func _on_coke_input_text_changed(new_text) -> void:
	soundfx(2)
	coke_input = int(new_text)
	if coke_input == null:
		coke_input = 1
	refresh_coke_ui()

func _on_pack_coke_pressed() -> void:
	for i in coke_input:
		match coke_pack_op:
			1:
				if baggies >= 1 and coke_unpackaged >= 1:
					coke_unpackaged -= 1
					baggies -= 1
					coke_packaged += 1
			2:
				if jars >= 1 and coke_unpackaged >= 5:
					coke_unpackaged -= 5
					jars -= 1
					coke_packaged += 5
			3:
				if coke_unpackaged >= 20 and brick_unlocked != false:
					coke_unpackaged -= 20
					coke_packaged += 20
	refresh_coke_ui()

func _on_coke_pack_op_item_selected(index: int) -> void:
	coke_pack_op = index + 1
	soundfx(2)
	refresh_coke_ui()

func _on_cook_coke_pressed() -> void:
	soundfx(2)
	for i in coke_input:
		if coke_leaves >= 1 and (cauldrons - active_cauldrons) >= 1:
			active_cauldrons += 1
			coke_leaves -= 1
			coke_unfinished += coke_yield
			var cook_timer:Timer = Timer.new()
			cook_timer.wait_time = 1
			var wait_time_stored:int = randi_range(boil_lower,boil_upper)
			var data = {"cooktime": 1}
			cook_timer.one_shot = false
			add_child(cook_timer)
			var pbar:ProgressBar = ProgressBar.new()
			pbar.show_percentage = true
			pbar.max_value = wait_time_stored + 1
			pbar.min_value = 0
			pbar.value = 1
			pbar.theme = load("res://UI/sale_coke.tres") as Theme
			meth_info.add_child(pbar)
			cook_timer.timeout.connect(boil_over.bind(cook_timer, pbar, wait_time_stored, data))
			cook_timer.start()
			print("Cauldron started")
			refresh_meth()

func boil_over(cook_timer: Timer, pbar: ProgressBar, wait_time_stored: int, data):
	data["cooktime"] += 1
	pbar.value = data["cooktime"]
	if data["cooktime"] >= (wait_time_stored + 1):
		print("Meth done")
		coke_unfinished -= coke_yield
		coke_unpackaged += coke_yield
		active_cauldrons -= 1
		pbar.queue_free()
		cook_timer.queue_free()
		refresh_coke_ui()

# COCAINE SALES:
var coke_sold_today:int = 0
@onready var coke_demandTimer: Timer = $Timers/Coke_Demand
