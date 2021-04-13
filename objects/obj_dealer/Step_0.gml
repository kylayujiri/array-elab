switch(global.state) {
	
	case global.state_start:
		var num_player_cards = ds_list_size(player_hand);
		var num_comp_cards = ds_list_size(comp_hand);
		
		// deal 3 cards into both hands
		if (num_player_cards < 3 && wait_time == 0) {
			var dealt_card = global.deck[| ds_list_size(global.deck) - 1];
			ds_list_add(player_hand, dealt_card);
			dealt_card.face_down = true;
			dealt_card.selectable = true;
			dealt_card.target_x = 272 + (num_player_cards * 112);
			dealt_card.target_y = 768;
			ds_list_delete(global.deck, ds_list_size(global.deck) - 1);
			audio_play_sound(snd_cardMove, 0, false);
			wait_time = 30;
		} else if (num_comp_cards < 3 && wait_time == 0) {
			var dealt_card = global.deck[| ds_list_size(global.deck) - 1];
			ds_list_add(comp_hand, dealt_card);
			dealt_card.face_down = true;
			dealt_card.target_x = 272 + (num_comp_cards * 112);
			dealt_card.target_y = 0;
			ds_list_delete(global.deck, ds_list_size(global.deck) - 1);
			audio_play_sound(snd_cardMove, 0, false);
			wait_time = 30;
		} else {
			
			if (wait_time == 0 && player_hand[| 0].face_down == true) {
				for (i = 0; i < 3; i++) {
					player_hand[| i].face_down = false;	
				}
				// wait_time = 30;
			}
			
			if (wait_time == 0) {
				// decide who is first
				global.turn = irandom(1);
				
				if (global.turn == 0) { // player goes first
					global.state = global.state_cardSelect;
				} else { // computer is first
					global.state = global.state_computer;
				}
			}
		}
		
		break;
		
		
	case global.state_computer:
	
		
	
		break;
	
	
	case global.state_cardSelect:
		
		if (mouse_check_button_pressed(mb_left) && global.selected != noone) {
			audio_play_sound(snd_cardMove, 0, false);
			global.player_chosen = global.selected;
			ds_list_delete(comp_hand, global.player_chosen);
			global.player_chosen.target_x = 384;
			global.player_chosen.target_y = 478;
			
			wait_time = 60;
			global.state = global.state_check;
		}
		
		break;
		
		
	case global.state_tileSelect:
	
	
		break;
		
		
	case global.state_check:
		
		if (global.comp_chosen.face_down == true && wait_time = 0) {
			global.comp_chosen.face_down = false;
			wait_time = 60;
		} else if (wait_time == 0) {
			if (global.player_chosen.type == "rock") {
				if (global.comp_chosen.type == "rock") {
					// tie
				
				} else if (global.comp_chosen.type == "paper") {
					// computer wins
					global.comp_score++;
					audio_play_sound(snd_loss, 0, false);
				} else { // computer is scissors
					// player wins
					global.player_score++;
					audio_play_sound(snd_win, 0, false);
				}
			}  else if (global.player_chosen.type == "paper") {
				if (global.comp_chosen.type == "rock") {
					// player wins
					global.player_score++;
					audio_play_sound(snd_win, 0, false);
				} else if (global.comp_chosen.type == "paper") {
					// tie
				
				} else { // computer is scissors
					// computer wins
					global.comp_score++;
					audio_play_sound(snd_loss, 0, false);
				}
			} else { // player is scisscors
				if (global.comp_chosen.type == "rock") {
					// computer wins
					global.comp_score++;
					audio_play_sound(snd_loss, 0, false);
				} else if (global.comp_chosen.type == "paper") {
					// player wins
					global.player_score++;
					audio_play_sound(snd_win, 0, false);
				} else { // computer is scissors
					// tie
				
				}
			}
			global.state = global.state_discard;
		}
		
		break;
		
		
	case global.state_discard:
		global.selected = noone;
		player_chosen = noone;
		comp_chosen = noone;
		
		while (ds_list_size(player_hand) > 0) {
			if (wait_time == 0) {
				var to_discard = player_hand[| 0];
				ds_list_add(global.discard, to_discard);
				ds_list_delete(player_hand, 0);
				to_discard.target_x = 683;
				to_discard.target_y = 383.5 - ((ds_list_size(global.discard) - 1) * 5);
				to_discard.selectable = false;
				to_discard.target_depth = to_discard.target_y;
				audio_play_sound(snd_cardMove, 0, false);
				wait_time = 30;
			}
			if (wait_time > 0) wait_time--;
		}
		
		while (ds_list_size(comp_hand) > 0) {
			if (wait_time == 0) {
				var to_discard = comp_hand[| 0];
				ds_list_add(global.discard, to_discard);
				ds_list_delete(comp_hand, 0);
				to_discard.target_x = 683;
				to_discard.target_y = 383.5 - ((ds_list_size(global.discard) - 1) * 5);
				to_discard.face_down = false;
				to_discard.target_depth = to_discard.target_y;
				to_discard.selectable = false;
				audio_play_sound(snd_cardMove, 0, false);
				wait_time = 30;
			}
			if (wait_time > 0) wait_time--;
		}
		show_debug_message(string(ds_list_size(global.discard)));
		if (ds_list_size(global.discard) == 24) {
			ds_list_shuffle(global.discard);
			global.state = global.state_reshuffle;
		} else {
			global.state = global.state_deal;	
		}
	
		break;
		
	
	case global.state_reshuffle:
		
		if (wait_time == 0) {
			audio_play_sound(snd_shuffle, 0, true);
			while (ds_list_size(global.discard) > 0) {
		
				var card = global.discard[| 0];
			
				ds_list_add(global.deck, card);
			
				card.face_down = true;
				card.target_x = 85;
				card.target_y = 383.5 - ((ds_list_size(global.deck) - 1) * 5);
				card.target_depth = ds_list_size(global.discard);
			
				ds_list_delete(global.discard, 0);
			}
			wait_time = 30;
			global.state = global.state_deal;
			audio_stop_sound(snd_shuffle);
		}
		
		break;
	

}

if (wait_time > 0) wait_time--;