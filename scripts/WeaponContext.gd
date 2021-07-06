extends Weapon

export(Array, PackedScene) var _weapon_list

var _current: Weapon


func _input(event: InputEvent) -> void:
	if event.is_action_released('change_weapon'):
		switch()


func _process(_delta: float) -> void:
#	for weapon in _weapon_list:
#		weapon._process(delta)
	Hud.set_weapon_cooldown_percent(_current._firing_cooldown / (1 / _current.attack_speed))
	Hud.set_ability_cooldown_percent(_current._abiliting_cooldown / (1 / _current.ability_speed))


func _ready() -> void:
	for i in range(len(_weapon_list)):
		_weapon_list[i] = _weapon_list[i].instance()
		add_child(_weapon_list[i])
		_weapon_list[i].base = get_parent()
		_weapon_list[i].damage_mask = damage_mask
#		_weapon_list[i]._init()
		_weapon_list[i]._ready()	
	_current = _weapon_list[0]


func toggle_fire(state: bool) -> void:
	_current.toggle_fire(state)


func toggle_ability(state: bool) -> void:
	_current.toggle_ability(state)


func fire():
	_current.fire()


func activate_ability(at: Vector2):
	_current.activate_ability(at)


func switch(i = -1):
	_current.toggle_fire(false)
	_current.toggle_ability(false)
	# if unspecified then get next on the list
	if i == -1:
		# search for current
		var cur_i: int = 0
		for weapon_i in range(len(_weapon_list)):
			if _weapon_list[weapon_i] == _current:
				cur_i = weapon_i
				break
		cur_i += 1
		if cur_i == len(_weapon_list):
			cur_i = 0
		_current = _weapon_list[cur_i]
	else:
		_current = _weapon_list[i]

	Hud.change_weapon_icon(_current.icon)
