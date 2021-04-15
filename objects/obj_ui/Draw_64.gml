draw_set_color(c_white);

draw_set_font(fnt_mont);

draw_set_halign(fa_center);
draw_set_valign(fa_center);

if (global.state == global.state_end) {

	draw_text(room_width * 0.5, room_height * 0.5 - 50, text_to_draw);
	
	draw_text(room_width * 0.5, room_height * 0.5 + 50, "Click anywhere to play again.");
	
}