extends Node

# STATUS:
var in_gui:bool = false
var in_pause:bool = false
var in_func:bool = false
var sleep_available:bool = false
var sleep_skips_day:bool = true
var sleep_initiated:bool = false
var loading_game:bool = false
var sleep_anim:bool = false
var playing_mobile:bool = false

# PLAYER PROGRESS - Use later to show things in 3D scene:
@export var purple_unlock:bool = false
@export var meth_unlock:bool = false
@export var coke_unlock:bool = false
var weed_staff:bool = false
var meth_staff:bool = false
var coke_staff:bool = false

# OPTIONS:
var v_sync:int = 0 # 0 = On, 1 = Off
var autosave:int = 0 # 0 = On, 1 = Off
var max_fps:int = 240
var mus_vol:float = 1
var sfx_vol:float = 1
var VOL:float = 1
var res:int = 2
var window:int = 0

# PLAYER STATS:
var kush_sales:int = 0
var p_sales:int = 0
var meth_sales:int = 0
var coke_sales:int = 0
var total_rev:int = 0

# FUNCTIONS MENU:
var room_col:Color = Color.BLACK
var tv_off:bool = true
var pots:bool = true
var comp_name:String = "COMPANY"
