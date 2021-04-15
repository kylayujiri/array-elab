
function checkWin(){
	// returns 1 if player wins
	// returns -1 if computer wins
	// returns 0 if no win state
	
	var s1 = ds_grid_get(global.board, 0, 0);
	var s2 = ds_grid_get(global.board, 1, 0);
	var s3 = ds_grid_get(global.board, 2, 0);
	var s4 = ds_grid_get(global.board, 0, 1);
	var s5 = ds_grid_get(global.board, 1, 1);
	var s6 = ds_grid_get(global.board, 2, 1);
	var s7 = ds_grid_get(global.board, 0, 2);
	var s8 = ds_grid_get(global.board, 1, 2);
	var s9 = ds_grid_get(global.board, 2, 2);

	// row 1
	if (typeAndOwner(s1, s2, s3)) return (s1.owner == 0) ? 1 : -1;
	
	// row 2
	if (typeAndOwner(s4, s5, s6)) return (s4.owner == 0) ? 1 : -1;
	
	// row 3
	if (typeAndOwner(s7, s8, s9)) return (s7.owner == 0) ? 1 : -1;
	
	// col 1
	if (typeAndOwner(s1, s4, s7)) return (s1.owner == 0) ? 1 : -1;
	
	// col 2
	if (typeAndOwner(s2, s5, s8)) return (s2.owner == 0) ? 1 : -1;
	
	// col 3
	if (typeAndOwner(s3, s6, s9)) return (s3.owner == 0) ? 1 : -1;
	
	// diag 1
	if (typeAndOwner(s1, s5, s9)) return (s1.owner == 0) ? 1 : -1;
	
	// diag 2
	if (typeAndOwner(s3, s5, s7)) return (s3.owner == 0) ? 1 : -1;
	
	// else there is no win state
	return 0;
}

function typeAndOwner(s1, s2, s3) {
	if (s1 != noone && s2 != noone && s3 != noone) {
		if (s1.type == s2.type && s2.type == s3.type && s1.owner == s2.owner && s2.owner == s3.owner) {
			// by the communatative property if all these are true then s1 type and owner == s3 type and owner :)
			return true;
		}
	}
	
	return false;
}