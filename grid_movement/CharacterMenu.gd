
extends PopupMenu 

var panel_container
var panel
var vbox_container
var info_button
var item_button
var attack_button
var trade_button
var recruit_button
var wait_button
var cancel_button

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	info_button.hide()
	item_button.hide()
	attack_button.hide()
	recruit_button.hide()
	trade_button.hide()
	wait_button.hide()
	cancel_button.hide()

	self.wait_button.connect("pressed", self, "_on_wait_action")
	self.cancel_button.connect("pressed", self, "_on_cancel_action")

func toggle_info_button(state):
	if (state):
		info_button.show()
	else:
		info_button.hide()

func toggle_item_button(state):
	if (state):
		item_button.show()
	else:
		item_button.hide()
	
func toggle_attack_button(state):
	if (state):
		attack_button.show()
	else:
		attack_button.hide()
	
func toggle_trade_button(state):
	if (state):
		trade_button.show()
	else:
		trade_button.hide()
		
func toggle_recruit_button(state):
	if (state):
		recruit_button.show()
	else:
		recruit_button.hide()
		
func toggle_wait_button(state):
	if (state):
		wait_button.show()
	else:
		wait_button.hide()

func toggle_cancel_button(state):
	if (state):
		cancel_button.show()
	else:
		cancel_button.hide()

func _on_wait_action():
	print('Wait Action')
	var parent = self.get_parent()
	parent.set_opacity(.60)
	#parent.get_node('Sprite').set_modulate(Color(1,1,1,.50))
	parent.is_active = false
	parent.is_enemy_nearby = false
	parent.is_selectable = false
	parent.attackable_areas.clear()
	parent.update() #redraw squares
	parent.end_turn()
	self.hide()

func _on_cancel_action():
	print('Cancel Action')
	var parent = self.get_parent()
	if (parent.original_position != null):
		parent.move_to(parent.original_position)
	parent.set_process_input(true)
	parent.is_active = false
	parent.is_enemy_nearby = false
	self.hide()
	
func _input(event):
	#Detect if mouse pointer has clicked outside the popup if so then reset the character
	if (event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and !event.is_echo()):
		if (self.is_visible()):
			if (!panel_container.get_global_rect().has_point(event.pos)):
				_on_cancel_action()
	
func _init():
	panel = Panel.new()
	vbox_container = VBoxContainer.new()
	
	info_button = Button.new()
	info_button.set_text("info")
	info_button.set_text_align(HALIGN_CENTER)
	
	item_button = Button.new()
	item_button.set_text("item")
	item_button.set_text_align(HALIGN_CENTER)
	
	attack_button = Button.new()
	attack_button.set_text("attack")
	attack_button.set_text_align(HALIGN_CENTER)
	
	trade_button = Button.new()
	trade_button.set_text("trade")
	trade_button.set_text_align(HALIGN_CENTER)
	
	recruit_button = Button.new()
	recruit_button.set_text("recruit")
	recruit_button.set_text_align(HALIGN_CENTER)
	
	wait_button = Button.new()
	wait_button.set_text("wait")
	wait_button.set_text_align(HALIGN_CENTER)
	
	cancel_button = Button.new()
	cancel_button.set_text("cancel")
	cancel_button.set_text_align(HALIGN_CENTER)
	
	vbox_container.add_child(info_button)
	vbox_container.add_child(item_button)
	vbox_container.add_child(attack_button)
	vbox_container.add_child(wait_button)
	vbox_container.add_child(trade_button)
	vbox_container.add_child(recruit_button)
	vbox_container.add_child(cancel_button)
	
	panel_container = PanelContainer.new()
	panel_container.add_child(panel)
	panel_container.add_child(vbox_container)
	self.add_child(panel_container)
	self.hide()