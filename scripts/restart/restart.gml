
function restart(){
	
	global.result = 0;
	global.turn = 0;
	global.state = global.state_start;
	global.selected_card = noone;
	global.selected_square = noone;
	
	chosen = noone;
	chosen_square = noone;
	chosen_i = noone;
	chosen_j = noone;
	chosen_board_card = noone;
	
	obj_darkBG.visible = false;

	while (ds_list_size(player_hand) > 0) {
		var card = player_hand[| 0];
		card.face_down = true;
		card.owner = noone;
		card.selectable = false;
		ds_list_add(global.deck, card);
		ds_list_delete(player_hand, 0);
	}
	
	while (ds_list_size(comp_hand) > 0) {
		var card = comp_hand[| 0];
		card.face_down = true;
		card.owner = noone;
		card.selectable = false;
		ds_list_add(global.deck, card);
		ds_list_delete(comp_hand, 0);
	}
	
	while (ds_list_size(global.discard) > 0) {
		var card = global.discard[| 0];
		card.face_down = true;
		card.owner = noone;
		card.selectable = false;
		ds_list_add(global.deck, card);
		ds_list_delete(global.discard, 0);
	}
	
	for (i = 0; i < 3; i++) {
		for (j = 0; j < 3; j++) {
			var card = ds_grid_get(global.board, i, j);
			if (card != noone) {
				card.face_down = true;
				card.owner = noone;
				card.selectable = false;
				ds_list_add(global.deck, card);
				ds_grid_set(global.board, i, j, noone);
			}
		}
	}
	
	ds_list_shuffle(global.deck);

	for (i = 0; i < global.num_cards; i++) {
		var card = global.deck[| i];
		card.target_x = obj_dealer.x;
		card.target_y = (room_height * 0.5) - (i * 5);
		card.target_depth = -i;
	}
	
	for (i = 0; i < instance_number(obj_square); i++) {
		var square = instance_find(obj_square, i);
		square.image_index = 2;
	}
}