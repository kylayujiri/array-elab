if (global.state == global.state_select && selectable) {
	
	if (position_meeting(mouse_x, mouse_y, id)) {
		
		global.selected = id;
		y = y - 5;
		
	} else if (global.selected == id) {
		
		global.selected = noone;
		y = y + 5;
		
	}
	
}