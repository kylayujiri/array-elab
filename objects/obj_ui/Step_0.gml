if (global.state == global.state_end) {

	if (global.result == 1) {
		
		text_to_draw = "You win!";
		
		if (!sound_has_played) {
			audio_play_sound(snd_win, 0, false);
			sound_has_played = true;
		}
	
	} else if (global.result == -1) {
	
		text_to_draw = "The computer wins!";
		
		if (!sound_has_played) {
			audio_play_sound(snd_loss, 0, false);
			sound_has_played = true;
		}
		
	} else {
	
		text_to_draw = "It's a tie!";
	
	}
	
	
}