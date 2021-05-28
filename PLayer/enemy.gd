extends KinematicBody2D


var speed = 80

var velocity = Vector2()

var stun = false

var enemy_hp = 3

var knockback = 6

var damage = 1

var damage_multiplier = 1

var poits_per_kill = 1

var kill_particle = preload("res://PLayer/Kill_particle.tscn")


func _process(delta):
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
		
	if enemy_hp <= 0:
		Global.score += poits_per_kill * damage_multiplier
		if Global.node_creation_parent != null:
			var kill_particle_instance = Global.instance_node(kill_particle, global_position, Global.node_creation_parent)
			kill_particle_instance.rotation = velocity.angle()
			
		
		queue_free()
		
	global_position += velocity * speed * delta



func _on_Hitbox_area_entered(area):
	
	if area.is_in_group("Enemy_damager") and stun == false:
		
		modulate = Color.white
		velocity = -velocity * knockback
		enemy_hp -= damage
		stun = true
		
		$Stun_timer.start()
		area.get_parent().queue_free()



func _on_Stun_timer_timeout():
	
	modulate = Color("ff0c00")
	stun = false