draw_set_color(c_white);

draw_set_font(fnt_mont);

draw_set_halign(fa_center);
draw_set_valign(fa_center);

if (global.state == global.state_end) {

	if (global.result == 1) {
		
		draw_text(room_width * 0.5, room_height * 0.5, "You win!");
	
	} else if (global.result == -1) {
	
		draw_text(room_width * 0.5, room_height * 0.5, "The computer wins!");
	
	} else {
	
		draw_text(room_width * 0.5, room_height * 0.5, "It's a tie!");
	
	}
	
	draw_text(room_width * 0.5, room_height * 0.5 + 100, "Press 'R' to play again.");
	
}