global.result = 0;

global.turn = 0;

global.state_start = 0;
global.state_computer = 1;
global.state_cardSelect = 2;
global.state_squareSelect = 3;
global.state_compare = 4;
global.state_check = 5;
global.state_deal = 6;
global.state_reshuffle = 7;
global.state_end = 8;

global.state = global.state_start;

global.num_cards = 24;
global.deck = ds_list_create();
global.discard = ds_list_create();

global.selected_card = noone;
global.selected_square = noone;

global.board = ds_grid_create(3,3);
ds_grid_clear(global.board, noone);

chosen = noone;
chosen_square = noone;
chosen_i = noone;
chosen_j = noone;
chosen_board_card = noone;

player_hand = ds_list_create();
comp_hand = ds_list_create();

comparison_depth = -26;
global.darkbg_depth = -25;
card_depth = 2;
global.square_depth = 3;

wait_time = 0;

for (i = 0; i < global.num_cards; i++) {
	
	var new_card = instance_create_layer(x, y, "Cards", obj_card);
	
	new_card.face_down = true;
	
	// set types
	if (i < global.num_cards / 3) {
		new_card.type = "rock";
	} else if (i < global.num_cards / 3 * 2) {
		new_card.type = "paper";
	} else {
		new_card.type = "scissors";
	}
	
	// set position
	new_card.target_x = x;
	new_card.target_y = y - i * 5;
	new_card.target_depth = 0 - ds_list_size(global.deck);
	
	ds_list_add(global.deck, new_card);
}

ds_list_shuffle(global.deck);

for (i = 0; i < global.num_cards; i++) {
	var card = global.deck[| i];
	card.target_y = (room_height * 0.5) - (i * 5);
	card.target_depth = -i;
}