draw_set_color(c_white);

draw_set_halign(fa_left);

draw_set_valign(fa_top);
draw_set_font(fnt_score);
draw_text(0 + x_offset, 0 + y_offset, global.comp_score);

draw_set_valign(fa_bottom);
draw_set_font(fnt_score);
draw_text(0 + x_offset, room_height - y_offset, global.player_score);