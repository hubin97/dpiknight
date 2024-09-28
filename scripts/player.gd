extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var ladder_ray_cast = $LadderRayCast

@onready var ladder_top = $"../LadderTops/LadderTop"

func _physics_process(delta):
	
	var ladderCollider = ladder_ray_cast.get_collider()
	if ladderCollider:
		_ladder_climb(delta)
	else:
		_movement(delta)
	
	_set_animation()
	
	move_and_slide()

# 基础移动和重力
func _movement(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#print(global_position)
	
# 设置精灵翻转
func _set_animation():
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

# 爬梯子
@warning_ignore("unused_parameter")
func _ladder_climb(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction:
		velocity = direction * SPEED/2
		#print(velocity.y)
		print(position.y)
	else:
		velocity = Vector2.ZERO
	
	if velocity:
		animated_sprite.play("run")
	else:
		animated_sprite.stop()
		
	# 处理位置
	position += velocity * delta  # 应用速度到角色位置

	var ladder_top_y = ladder_top.position.y
	#print("ladder_top:", ladder_top)
	#print("position:", self.global_position.y)
	# 到达顶部条件
	var condition = velocity.y > 0 && self.global_position.y - ladder_top_y + 5 <= 0
	print("condition:", condition)
	print("velocity", velocity)
	if condition:
		self.global_position.y = ladder_top_y - 15
		print("已经到梯子顶部")
	else:
		print("正在爬梯子")
