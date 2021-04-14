global.player_score = 0;
global.comp_score = 0;

global.turn = 0;

global.state_start = 0;
global.state_computer = 1;
global.state_cardSelect = 2;
global.state_tileSelect = 3;
global.state_compare = 4;
global.state_check = 5;
global.state_deal = 6;
global.state_reshuffle = 7;
global.state_end = 8;

global.state_reshuffle = 5;

global.state = global.state_deal;

global.num_cards = 24;
global.deck = ds_list_create();
global.discard = ds_list_create();

global.selected = noone;

global.board = ds_grid_create(3,3);
ds_grid_clear(global.board, noone);

player_chosen = noone;
comp_chosen = noone;
comp_chosen_i = noone;
comp_chosen_j = noone;

player_hand = ds_list_create();
comp_hand = ds_list_create();

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
	new_card.target_depth = new_card.target_y;
	
	ds_list_add(global.deck, new_card);
}

ds_list_shuffle(global.deck);

for (i = 0; i < global.num_cards; i++) {
	var card = global.deck[| i];
	card.target_y = (room_height * 0.5) - (i * 5);
	card.target_depth = -i;
}