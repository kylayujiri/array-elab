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
		// look at each card and test each valid space
		
		// choices from most optimal to least optimal
			// 3 in a row (win)
			// block a player win
			// move that enables multiple two in a rows
				// includes when the third is beatable by the type we are looking at
				// (e.g. rock scissors rock can become rock rock rock)
			// move that enables 1 two in a row w/ a valid third
				// analyze as if player would put in the third and see which is best
			// move that that enables a two in a row w/o a valid third
			
		if (comp_chosen == noone) {
			
			var checkedRock = false;
			var checkedPaper = false;
			var checkedScissors = false;
			
			var def_chosen = false;
			
			var maxNumTwos = 0;
			
			for (i = 0; i < ds_list_size(comp_hand); i++) {
				// for each card in the hand
				
				var card = comp_hand[| i];
				
				if (card.type == "rock" && checkedRock) {
					continue;	
				} else if (card.type == "paper" && checkedPaper) {
					continue;	
				} else if (card.type == "scissors" && checkedScissors) {
					continue;	
				} else {
					
					// for every valid square
					for (j = 0; j < 3; j++) {
						for (k = 0; k < 3; k++) {
							if (canPlace(j, k, card.type)) {
								
								// can we win
								if (three(j, k, card.type, global.turn)) {
									comp_chosen = card;
									comp_chosen_i = j;
									comp_chosen_j = k;
									def_chosen = true;
									break;
								}
								
								// can we block the player from winning
								if (three(j, k, "rock", 0) || three(j, k, "paper", 0) || three(j, k, "scissors", 0)) {
									comp_chosen = card;
									comp_chosen_i = j;
									comp_chosen_j = k;
									def_chosen = true;
									break;
								}
								
								// count multiple twos
								var numTwos = countTwos(j, k, card.type, global.turn);
								if (numTwos > maxNumTwos) {
									maxNumTwos = numTwos;
									comp_chosen = card;
									comp_chosen_i = j;
									comp_chosen_j = k;
								}
							}
						}
						
					} // end of iteration through squares
					
					if (def_chosen) {
						break;	
					}
				
					if (card.type == "rock") {
						checkedRock = true;
					} else if (card.type == "paper" && checkedPaper) {
						checkedPaper = true;
					} else if (card.type == "scissors" && checkedScissors) {
						checkedScissors = true;
					}
				}
				
			} // end iteration through hand
			
			// after the for loop is done, if we still have not chosen (board is probably p empty)
			if (comp_chosen == noone) {
				if (ds_grid_get(global.board, 1, 1) == noone) {
					comp_chosen = comp_hand[| irandom(ds_list_size(comp_hand) - 1)];
					comp_chosen_i = 1;
					comp_chosen_j = 1;
				} else if (cornersTaken() < 2) {
					comp_chosen = comp_hand[| irandom(ds_list_size(comp_hand) - 1)];
					var corner = getFreeCorner();
					if (corner == 0) {
						comp_chosen_i = 0;
						comp_chosen_j = 0;
					} else if (corner == 1) {
						comp_chosen_i = 2;
						comp_chosen_j = 0;
					} else if (corner == 2) {
						comp_chosen_i = 0;
						comp_chosen_j = 2;
					} else {
						comp_chosen_i = 2;
						comp_chosen_j = 2;
					}
				} else { // choosen an edge
					var edge = getFreeEdge();
					if (edge == 0) {
						comp_chosen_i = 1;
						comp_chosen_j = 0;
					} else if (edge == 1) {
						comp_chosen_i = 2;
						comp_chosen_j = 1;
					} else if (edge == 2) {
						comp_chosen_i = 1;
						comp_chosen_j = 2;
					} else {
						comp_chosen_i = 0;
						comp_chosen_j = 1;
					}
				}
			}
			
			if (comp_chosen == noone) {
				// if we STILL haven't chosen one, just choose the first valid one
				for (i = 0; i < 3; i++) {
					for (j = 0; j < 3; j++) {
						for (k = 0; k < ds_list_size(comp_hand); k++) {
							var card = comp_hand[| k];
							if (canPlace(i, j, card.type)) {
								comp_chosen = card;
								comp_chosen_i = i;
								comp_chosen_j = j;
							}
						}
					}
				}
			
			}
			
			// now that we finally have a comp_chosen
			comp_chosen.target_y = 73;
			var chosen_index = ds_list_find_index(comp_hand, comp_chosen);
			ds_list_delete(comp_hand, chosen_index);
			wait_time = 30;
		
		} else if (comp_chosen.face_down == true && wait_time == 0) {
			comp_chosen.face_down = false;
			wait_time = 30;
		} else {
			if (ds_grid_get(global.board, comp_chosen_i, comp_chosen_j) != noone) {
				global.state = global.state_compare;	
			}
		}
		
		
	
		break;
	
	
	case global.state_cardSelect:
		
		if (mouse_check_button_pressed(mb_left) && global.selected != noone) {
			audio_play_sound(snd_cardMove, 0, false);
			player_chosen = global.selected;
			
			player_chosen.target_y = 694;
			var chosen_index = ds_list_find_index(player_hand, player_chosen);
			ds_list_delete(player_hand, chosen_index);
			
			global.state = global.state_tileSelect;
		}
		
		break;
		
		
	case global.state_tileSelect:
	
		
	
		break;
		
	
	case global.state_compare:
		
		// add dark opacity background
		obj_darkBG.visible = true;
		obj_darkBG.depth = 768;
		
		var new_card, board_card, i, j;
		
		if (turn == 0) {
			
			new_card = player_chosen;
			i = player_chosen_i;
			j = player_chosen_j;
			
		} else {
			new_card = comp_chosen;
			i = comp_chosen_i;
			j = comp_chosen_j;
		}
		
		board_card = ds_grid_get(global.board, i, j);
		
		// move cards
		new_card.target_x = 306;
		new_card.target_y = room_height * 0.5;
		new_card.target_depth = 769;
			
		board_card.target_x = 466;
		board_card.target_y = room_height * 0.5;
		board_card.target_depth = 769;
			
		if (beats(new_card.type, board_card.type) == 1) {
			
			audio_play_sound(snd_cardMove, 0, false);
				
			// discard board card
			ds_list_add(global.discard, board_card);
			board_card.target_x = 683;
			board_card.target_y = 383.5 - ((ds_list_size(global.discard) - 1) * 5);
			board_card.selectable = false;
			board_card.target_depth = board_card.target_y;
			
			// move new card to position
			new_card.target_x = 228 + (i * 156);
			new_card.target_y = 228 + (j * 156);
			new_card.target_depth = new_card.target_y;
				
		} else {
				
			// discard new card (ties and when board card beats new card)
			audio_play_sound(snd_cardMove, 0, false);
				
			// discard new card
			ds_list_add(global.discard, new_card);
			new_card.target_x = 683;
			new_card.target_y = 383.5 - ((ds_list_size(global.discard) - 1) * 5);
			new_card.selectable = false;
			new_card.target_depth = new_card.target_y;
			
			// move board_card to position
			board_card.target_x = 228 + (i * 156);
			board_card.target_y = 228 + (j * 156);
			board_card.target_depth = board_card.target_y;
				
		}
		
		global.selected = noone;
		
		player_chosen = noone;
		player_chosen_i = noone;
		player_chosen_j = noone;
		
		comp_chosen = noone;
		comp_chosen_i = noone;
		comp_chosen_j = noone;
	
		break;
		
		
	case global.state_check:
		
		if (global.comp_chosen.face_down == true && wait_time = 0) {
			global.comp_chosen.face_down = false;
			wait_time = 60;
		} else if (wait_time == 0) {
			if (player_chosen.type == "rock") {
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
			}  else if (player_chosen.type == "paper") {
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
	
	case global.state_deal:
	
	
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
	
	
	case global.state_end:
		
		
		break;
		

}

if (wait_time > 0) wait_time--;