extends Node

@export var mob_scene: PackedScene
@export var ghost_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time. # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$music.stop()
	pass
	
func new_game():
	score = 0
	$player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$music.play() # Replace with function body.


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	pass # Replace with function body.


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	pass # Replace with function body.


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	var ghost = ghost_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	var ghost_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	ghost_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation# + PI / 2
	var ghost_direction = ghost_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	ghost.position = ghost_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	ghost_direction += randf_range(-PI / 4, PI / 4)
	ghost.rotation = ghost_direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(250.0, 500.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	if score > 25:
		var ghost_velocity = Vector2(randf_range(50.0, 1000.0), 0.0)
		ghost.linear_velocity = ghost_velocity.rotated(ghost_direction)
	else:
		var ghost_velocity = Vector2(randf_range(50.0, 500.0), 0.0)
		ghost.linear_velocity = ghost_velocity.rotated(ghost_direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	if score > 20 and randf_range(1, 50) > 20:
		add_child(mob)
	elif score > 10 and randf_range(1, 100) > 85:
		add_child(mob)
	if score > 30 and randf_range(1, 10) > 3:
		add_child(ghost)
	elif score > 15 and randf_range(1, 10) > 5:
		add_child(ghost)
	pass
	 # Replace with function body.
func _ready() -> void:
	new_game()
	pass
