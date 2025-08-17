extends CanvasLayer

var hearts : Array[HeartGUI] = []

func _ready() -> void:
	# instantiate hearts array
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false
	pass
	
func UpdateHp(_hp:int, _max_hp:int) -> void:
	UpdateMaxHp(_max_hp)
	for i in _max_hp:
		UpdateHeart(_hp, i)
		pass
	pass

func UpdateHeart(_hp:int, _index:int) -> void:
	var _value : int = clampi(_hp - _index * 2, 0 ,2) # calculate value for heart
	hearts[_index].value = _value
	pass

func UpdateMaxHp(_max_hp : int) -> void:
	var _heart_count : int = roundi(_max_hp * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass
