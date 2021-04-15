switch(global.state) {
	
	case global.state_start:
		// show_debug_message("state: " + string(global.state));
	
		var num_player_cards = ds_list_size(player_hand);
		var num_comp_cards = ds_list_size(comp_hand);
		
		// deal 3 cards into both hands
		if (num_player_cards < 3 && wait_time == 0) {
			
			// get card from the top of the deck
			var dealt_card = global.deck[| ds_list_size(global.deck) - 1];
			
			// add card to the player hand
			ds_list_add(player_hand, dealt_card);
			
			// modify the card's variables
			dealt_card.face_down = true;
			dealt_card.selectable = true;
			dealt_card.owner = 0;
			
			// move the card
			// num_player_cards has not been updated yet (so it's 0, 1, or 2)
			dealt_card.target_x = 272 + (num_player_cards * 112);
			dealt_card.target_y = 768;
			
			// delete the top card from the deck b/c it's in the player hand now
			ds_list_delete(global.deck, ds_list_size(global.deck) - 1);
			
			// play the move sound
			audio_play_sound(snd_cardMove, 0, false);
			
			// add a wait time before the next card it dealt
			wait_time = 30;
			
		} else if (num_comp_cards < 3 && wait_time == 0) {
			
			// get card from the top of the deck
			var dealt_card = global.deck[| ds_list_size(global.deck) - 1];
			
			// add card to the player hand
			ds_list_add(comp_hand, dealt_card);
			
			// modify the card's variables
			dealt_card.face_down = true;
			dealt_card.owner = 1;
			
			// move the card
			dealt_card.target_x = 272 + (num_comp_cards * 112);
			dealt_card.target_y = 0;
			
			// delete the top card of the deck b/c that card is in comp hand now
			ds_list_delete(global.deck, ds_list_size(global.deck) - 1);
			
			// play move sound
			audio_play_sound(snd_cardMove, 0, false);
			
			// add wait time before next card is dealt or before flipping player's cards
			wait_time = 30;
		} else {
			
			// if we have not flipped yet
			if (wait_time == 0 && player_hand[| 0].face_down == true) {
				
				// flip all three cards
				for (i = 0; i < 3; i++) {
					player_hand[| i].face_down = false;	
				}
				
			}
			
			if (wait_time == 0) {
				// decide who is first
				global.turn = irandom(1);
				
				if (global.turn == 0) { // player goes first
					global.state = global.state_cardSelect;
				} else { // computer goes first
					global.state = global.state_computer;
				}
			}
		}
		
		break;
		
		
	case global.state_computer:
		// show_debug_message("state: " + string(global.state));
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
			
		
		// if we have not chosen a card yet
		if (chosen == noone) {
			
			// variables to increase efficiency
			var checkedRock = false;
			var checkedPaper = false;
			var checkedScissors = false;
			
			// to get out of the loops if we are sure of our choice
			var def_chosen = false;
			
			// to keep track of which square creates more opportunities
			var maxNumTwos = 0;
			
			// for each card in the hand
			for (i = 0; i < ds_list_size(comp_hand); i++) {
				
				var card = comp_hand[| i];
				
				// if we have already checked a card of this type
				// answer will be the same for either
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
								
								if (def_chosen) { // if def_chosen == true but we're still looping,
												  // the only better option would be a three in a row
									// can we win
									if (three(j, k, card.type, global.turn)) {
										chosen = card;
										chosen_i = j;
										chosen_j = k;
										def_chosen = true;
										break;
									}
								} else {
									
									// can we win
									if (three(j, k, card.type, global.turn)) {
										chosen = card;
										chosen_i = j;
										chosen_j = k;
										def_chosen = true;
										break;
									}
								
									// can we block the player from winning
									if (three(j, k, "rock", 0) || three(j, k, "paper", 0) || three(j, k, "scissors", 0)) {
										chosen = card;
										chosen_i = j;
										chosen_j = k;
										def_chosen = true;
									}
								
									// count multiple twos
									var numTwos = countTwos(j, k, card.type, global.turn);
									if (numTwos > maxNumTwos) {
										maxNumTwos = numTwos;
										chosen = card;
										chosen_i = j;
										chosen_j = k;
									}
								}
								
							} // end if (canPlace())
							
						} // end for (k ...)
						
					} // end for (j...)
					
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
					
				} // end else
				
			} // end iteration through hand
			
			// after the for loop is done, if we still have not chosen (board is probably p empty)
			if (chosen == noone) {
				
				if (ds_grid_get(global.board, 1, 1) == noone) {
					// place in center
					
					chosen = comp_hand[| irandom(ds_list_size(comp_hand) - 1)];
					chosen_i = 1;
					chosen_j = 1;
					
				} else if (cornersTaken() < 2) {
					// place in corner if there are more than two empty
					
					chosen = comp_hand[| irandom(ds_list_size(comp_hand) - 1)];
					
					var corner = getFreeCorner();
					
					if (corner == 0) {
						chosen_i = 0;
						chosen_j = 0;
					} else if (corner == 1) {
						chosen_i = 2;
						chosen_j = 0;
					} else if (corner == 2) {
						chosen_i = 0;
						chosen_j = 2;
					} else {
						chosen_i = 2;
						chosen_j = 2;
					}
					
				} else { // choosen an edge
					
					var edge = getFreeEdge();
					
					if (edge == 0) {
						chosen_i = 1;
						chosen_j = 0;
					} else if (edge == 1) {
						chosen_i = 2;
						chosen_j = 1;
					} else if (edge == 2) {
						chosen_i = 1;
						chosen_j = 2;
					} else {
						chosen_i = 0;
						chosen_j = 1;
					}
					
				}
				
			}
			
			if (chosen == noone) {
				// if we STILL haven't chosen one, just choose the first valid one
				for (i = 0; i < 3; i++) {
					for (j = 0; j < 3; j++) {
						for (k = 0; k < ds_list_size(comp_hand); k++) {
							var card = comp_hand[| k];
							if (canPlace(i, j, card.type)) {
								chosen = card;
								chosen_i = i;
								chosen_j = j;
								break;
							}
						}
						if (chosen != noone) break;
					}
					if (chosen != noone) break;
				}
			
			}
			
			// now we finally have a chosen card
			
			chosen.target_y = 73; // move the chosen card
			
			// delete the chosen card from comp_hand
			var chosen_index = ds_list_find_index(comp_hand, chosen); 
			ds_list_delete(comp_hand, chosen_index);
			
			wait_time = 30;
		
		// end of if chosen == noone
		} else if (chosen.face_down == true && wait_time == 0) {
			
			audio_play_sound(snd_cardMove, 0, false);
			chosen.face_down = false;
			wait_time = 30;
			
		} else if (wait_time == 0) {
			
			if (ds_grid_get(global.board, chosen_i, chosen_j) != noone) {
				// if there's a card already in the space we want
				
				global.state = global.state_compare;	
				
			} else {
				
				// move card directly to the board
				audio_play_sound(snd_cardMove, 0, false);
				
				chosen.target_x = 228 + (chosen_i * 156);
				chosen.target_y = 228 + (chosen_j * 156);
				chosen.target_depth = card_depth;
				chosen.selectable = false;
				
				ds_grid_set(global.board, chosen_i, chosen_j, chosen);
				
				var square = instance_nearest(228 + (chosen_i * 156), 228 + (chosen_j * 156), obj_square);
				square.image_index = chosen.owner;
				
				global.state = global.state_check;
				wait_time = 30;
				
			}
			
		}
		
		
	
		break;
	
	
	case global.state_cardSelect:
		// show_debug_message("state: " + string(global.state));
		
		if (mouse_check_button_pressed(mb_left) && global.selected_card != noone) {
			audio_play_sound(snd_cardMove, 0, false);
			chosen = global.selected_card;
			
			chosen.target_y = 694;
			
			var chosen_index = ds_list_find_index(player_hand, chosen);
			ds_list_delete(player_hand, chosen_index);
			
			global.state = global.state_squareSelect;
		}
		
		break;
		
		
	case global.state_squareSelect:
		// show_debug_message("state: " + string(global.state));
	
		if (mouse_check_button_pressed(mb_left) && global.selected_square != noone) {
			chosen_square = global.selected_square;
			chosen_i = chosen_square.i;
			chosen_j = chosen_square.j;
			
			if (ds_grid_get(global.board, chosen_i, chosen_j) != noone) {
				global.state = global.state_compare;
			} else {
				// move card directly to the board
				audio_play_sound(snd_cardMove, 0, false);
				
				chosen.target_x = 228 + (chosen_i * 156);
				chosen.target_y = 228 + (chosen_j * 156);
				chosen.target_depth = card_depth;
				chosen.selectable = false;
				
				ds_grid_set(global.board, chosen_i, chosen_j, chosen);
				
				chosen_square.image_index = chosen.owner;
				
				global.state = global.state_check;
				wait_time = 30;
			}
		}
	
		break;
		
	
	case global.state_compare:
		// show_debug_message("state: " + string(global.state));
		
		if (chosen_board_card == noone) {
			// add dark opacity background
			obj_darkBG.visible = true;
		
			chosen_board_card = ds_grid_get(global.board, chosen_i, chosen_j);
		
			// move cards to middle
			chosen.target_x = 306;
			chosen.target_y = room_height * 0.5;
			chosen.target_depth = comparison_depth;
			
			chosen_board_card.target_x = 466;
			chosen_board_card.target_y = room_height * 0.5;
			chosen_board_card.target_depth = comparison_depth;
			
			wait_time = 60;
			
		} else if (chosen_board_card != noone && wait_time = 0) {
			
			obj_darkBG.visible = false;
		
			if (beats(chosen.type, chosen_board_card.type) == 1) {
			
				audio_play_sound(snd_cardMove, 0, false);
				
				// discard board card
				ds_list_add(global.discard, chosen_board_card);
				chosen_board_card.target_x = 694.5;
				chosen_board_card.target_y = room_height * 0.5 - ((ds_list_size(global.discard) - 1) * 5);
				chosen_board_card.target_depth = card_depth;
				chosen_board_card.owner = noone;
			
				// move chosen card to position
				chosen.target_x = 228 + (chosen_i * 156);
				chosen.target_y = 228 + (chosen_j * 156);
				chosen.target_depth = card_depth;
				chosen.selectable = false;
				
				ds_grid_set(global.board, chosen_i, chosen_j, chosen);
				
				var square = instance_nearest(228 + (chosen_i * 156), 228 + (chosen_j * 156), obj_square);
				square.image_index = chosen.owner;
				
			} else {
				
				// discard chosen card (ties and when board card beats chosen card)
				audio_play_sound(snd_cardMove, 0, false);
				
				// discard chosen card
				ds_list_add(global.discard, chosen);
				chosen.target_x = 694.5;
				chosen.target_y = room_height * 0.5 - ((ds_list_size(global.discard) - 1) * 5);
				chosen.selectable = false;
				chosen.target_depth = card_depth;
				chosen.owner = noone;
			
				// move board_card to board position
				chosen_board_card.target_x = 228 + (chosen_i * 156);
				chosen_board_card.target_y = 228 + (chosen_j * 156);
				chosen_board_card.target_depth = card_depth;
				
			}
			
			global.state = global.state_check;
			wait_time = 30;
		
		}
	
		break;
		
		
	case global.state_check:
		// show_debug_message("state: " + string(global.state));
	
		// reset selections from the turn
		global.selected_card = noone;
		global.selected_square = noone;
		chosen = noone;
		chosen_i = noone;
		chosen_j = noone;
		chosen_board_card = noone;
		
		// checks if the board is in a win state
		if (wait_time = 0) {
			var num_player_cards = ds_list_size(player_hand);
			var num_comp_cards = ds_list_size(comp_hand);
			
			// do the check
			global.result = checkWin();
			
			if (global.result == 1 || global.result == -1) {
				global.state = global.state_end;	
			} else if (global.result == 0 && num_player_cards == 0 && num_comp_cards == 0) {
				// if this is true, go to end screen even if there is not a win state
				global.state = global.state_end;
			} else {
				global.state = global.state_deal;	
			}
			
		}
		
		break;
	
	case global.state_deal:
		// show_debug_message("state: " + string(global.state));
	
		var num_player_cards = ds_list_size(player_hand);
		var num_comp_cards = ds_list_size(comp_hand);
		var num_in_deck = ds_list_size(global.deck);
		
		if (num_in_deck == 0) {
			
			if (ds_list_size(global.discard) > 0) {
				global.state = global.state_reshuffle;
			} else if (num_player_cards == 0 && num_comp_cards == 0) {
				global.state = global.state_check;
			} else {
				
				// continue playing w/o dealing
				
				// shift cards if necessary
				if (global.turn == 0 && num_player_cards < 3) {
					for (i = 0; i < num_player_cards; i++) {
						var card = player_hand[| i];
						card.target_x = 272 + (i * 112);
						card.target_depth = card_depth;
						
						for (wait = 30; wait > 0; wait--) {
						
						}
					}
				} else if (global.turn == 1 && num_comp_cards < 3) {
					for (i = 0; i < num_comp_cards; i++) {
						var card = comp_hand[| i];
						card.target_x = 272 + (i * 112);
						card.target_depth = card_depth;
						
						for (wait = 30; wait > 0; wait--) {
						
						}
					}
				}
				
				global.turn = (global.turn == 0) ? 1 : 0;
				global.state = (global.turn == 0) ? global.state_cardSelect : global.state_computer;
			}
			
		} else {
			// we can deal from the deck
			
			// shift cards if necessary
			if (global.turn == 0 && num_player_cards < 3) {
				for (i = 0; i < num_player_cards; i++) {
					var card = player_hand[| i];
					card.target_x = 272 + (i * 112);
					card.target_depth = card_depth;
					
					for (wait = 30; wait > 0; wait--) {
						
					}
				}
			} else if (global.turn == 1 && num_comp_cards < 3) {
				for (i = 0; i < num_comp_cards; i++) {
					var card = comp_hand[| i];
					card.target_x = 272 + (i * 112);
					card.target_depth = card_depth;
					
					for (wait = 30; wait > 0; wait--) {
						
					}
				}
			}
			
			var toAdd = global.deck[| num_in_deck - 1];
			
			if (global.turn == 0) {
				
				audio_play_sound(snd_cardMove, 0, false);
				
				ds_list_add(player_hand, toAdd);
				toAdd.owner = 0;
				toAdd.target_x = 272 + (max(0, ds_list_size(player_hand) - 1) * 112);
				toAdd.target_y = 768;
				toAdd.face_down = false;
				toAdd.selectable = true;
				toAdd.target_depth = card_depth;
			
			} else {
				
				audio_play_sound(snd_cardMove, 0, false);
			
				ds_list_add(comp_hand, toAdd);
				toAdd.owner = 1;
				toAdd.target_x = 272 + (max(0, ds_list_size(comp_hand) - 1) * 112);
				toAdd.target_y = 0;
				toAdd.target_depth = card_depth;
				
			}
			
			ds_list_delete(global.deck, num_in_deck - 1);
			
			global.turn = (global.turn == 0) ? 1 : 0;
			global.state = (global.turn == 0) ? global.state_cardSelect : global.state_computer;
			
		}
	
		break;
	
	case global.state_reshuffle:
		// show_debug_message("state: " + string(global.state));
		
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
			
			ds_list_shuffle(global.deck);
			
			global.state = global.state_deal;
			audio_stop_sound(snd_shuffle);
		}
		
		break;
	
	
	case global.state_end:
		// show_debug_message("state: " + string(global.state));
		
		obj_darkBG.visible = true;
		
		if (mouse_check_button_pressed(mb_left)) {
			game_restart();	
		}
		
		break;
		

}

if (wait_time > 0) wait_time--;