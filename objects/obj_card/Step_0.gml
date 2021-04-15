if (global.state == global.state_cardSelect && selectable) {
	
	if (position_meeting(mouse_x, mouse_y, id)) {
		
		global.selected_card = id;
		y = y - 5;
		
	} else if (global.selected_card == id) {
		
		global.selected_card = noone;
		y = y + 5;
		
	}
	
}