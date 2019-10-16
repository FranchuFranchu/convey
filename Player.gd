extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const GRAVITY = 1500.0
const MAX_SPEED = 400
var THISSPRITE
var THISTILEMAP
const ACC_SPEED = 10
var JUMPING = true
var somebool = false
var velocity = Vector2()
var conveyvelocity = Vector2()
var ANIMATIONS = {
	"runleft": "runleft",
	"runright": "runright",
	"standleft": "standleft",
	"standright": "standright",
}

var TILE_FORCES = {
	-1: Vector2(0,0),
	0: Vector2(200,0),
	1: Vector2(-200,0)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	THISSPRITE = get_node('AnimatedSprite')
	THISTILEMAP = get_node('../TileMap')
	pass # Replace with function body.

func global_to_tilemap(vec):
	return Vector2(floor(vec.x / THISTILEMAP.cell_size.x), floor(vec.y / THISTILEMAP.cell_size.y))

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	if is_on_floor():
		print('!')
		var tilemappos = THISTILEMAP.world_to_map(position)
		tilemappos.y += 1
		var tile_under_me = THISTILEMAP.get_cell(tilemappos.x, tilemappos.y)
		tilemappos.x += .1
		print(tilemappos)
		var tile_right_of_me = THISTILEMAP.get_cell(ceil(tilemappos.x), ceil(tilemappos.y))
		tilemappos.x -= .2
		print(tilemappos)
		var tile_left_of_me = THISTILEMAP.get_cell(floor(tilemappos.x), floor(tilemappos.y))
		if tile_under_me == -1:
			tile_under_me = max(tile_left_of_me, tile_right_of_me)
		conveyvelocity = TILE_FORCES[tile_under_me]
		velocity.y = 0
		JUMPING = false
	if Input.is_action_pressed("ui_left"):
		if velocity.x > -MAX_SPEED:
			velocity.x += -ACC_SPEED
			if THISSPRITE.animation != ANIMATIONS["runleft"]:
				THISSPRITE.play("runleft")
	elif Input.is_action_pressed("ui_right"):
		if velocity.x < MAX_SPEED:
			velocity.x += ACC_SPEED
			if THISSPRITE.animation != ANIMATIONS["runright"]:
				THISSPRITE.play("runright")
	else:
		if velocity.x < 0:
			velocity.x += ACC_SPEED
			
			if THISSPRITE.animation != ANIMATIONS["standleft"]:
				THISSPRITE.play("standleft")
		elif velocity.x > 0:
			velocity.x -= ACC_SPEED
			if THISSPRITE.animation != ANIMATIONS["standright"]:
				THISSPRITE.play("standright")
		if abs(velocity.x) < ACC_SPEED:
			velocity.x = 0
	if Input.is_action_pressed("ui_up") and (is_on_floor() or is_on_wall() ):
		print('j')
		JUMPING = true
		velocity.y = -600
		conveyvelocity = Vector2(0,0)
	var motion = (velocity + conveyvelocity) * delta * 60
	move_and_slide(motion, Vector2(0, -1))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass