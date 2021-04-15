if (global.state == global.state_squareSelect) {
	
	if (position_meeting(mouse_x, mouse_y, id)) {
		
		global.selected_square = id;
		
	} else if (global.selected_square == id) {
		
		global.selected_square = noone;
		
	}
	
}