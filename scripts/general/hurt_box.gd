class_name HurtBox extends Area2D

@export var damage : int = 1 # damage to cause to hitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		(area as HitBox).TakeDamage(damage)  # Ensure safe cast
