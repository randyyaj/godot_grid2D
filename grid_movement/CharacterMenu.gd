
extends PopupMenu 

var panel_container
var panel
var vbox_container
var item_button
var attack_button
var trade_button
var wait_button
var cancel_button
var toggle_state
var original_location

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	print('In ready')
	self.wait_button.connect("pressed", self, "_on_wait_action")
	self.cancel_button.connect("pressed", self, "_on_cancel_action")
		
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
	
func show_trade_button(state):
	if (state):
		trade_button.show()
	else:
		trade_button.hide()
		
func show_wait_button(state):
	if (state):
		wait_button.show()
	else:
		wait_button.hide()

func show_cancel_button(state):
	if (state):
		cancel_button.show()
	else:
		cancel_button.hide()

func _on_wait_action():
	print('Wait Action')
	var parent = self.get_parent()
	parent.set_opacity(.60)
	#parent.get_node('Sprite').set_modulate(Color(1,1,1,.50))
	parent.set_process_input(false)
	#print (self.get_parent().get_path().size())
	self.hide()

func _on_cancel_action():
	print('Cancel Action')
	var parent = self.get_parent()
	parent.move_to(original_location)
	self.hide()

func set_original_location(location):
	self.original_location = location

func _init():
	panel = Panel.new()
	vbox_container = VBoxContainer.new()
	
	item_button = Button.new()
	item_button.set_text("item")
	item_button.set_text_align(HALIGN_CENTER)
	
	attack_button = Button.new()
	attack_button.set_text("attack")
	attack_button.set_text_align(HALIGN_CENTER)
	
	trade_button = Button.new()
	trade_button.set_text("trade")
	trade_button.set_text_align(HALIGN_CENTER)
	
	wait_button = Button.new()
	wait_button.set_text("wait")
	wait_button.set_text_align(HALIGN_CENTER)
	
	cancel_button = Button.new()
	cancel_button.set_text("cancel")
	cancel_button.set_text_align(HALIGN_CENTER)
	
	vbox_container.add_child(item_button)
	vbox_container.add_child(attack_button)
	vbox_container.add_child(wait_button)
	vbox_container.add_child(trade_button)
	vbox_container.add_child(cancel_button)
	
	panel_container = PanelContainer.new()
	panel_container.add_child(panel)
	panel_container.add_child(vbox_container)
	self.add_child(panel_container)
	
	toggle_state = false
	self.hide()