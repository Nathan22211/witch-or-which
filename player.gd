extends Area2D
signal hit

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right"):
		velocity.x += 1
		speed = 200
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		speed = 200
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	#	$AnimatedSprite2D.play()
	#else:
	#	$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body):
	if body.is_in_group("mobs"):
		
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	elif body.is_in_group("cloud"):
		speed = 100

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
