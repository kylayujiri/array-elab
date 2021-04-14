function canPlace(i, j, type) {
	var current = ds_grid_get(global.board, i, j);
	
	if (current != noone) {
	
		if (beats(type, current.type) != 1) { // we can't place here
			return false;
		} else {
			return true;	
		}
		
	} else {
		return true;
	}
}

function three(i, j, type, turn) {
	
	var i1, i2, j1, j2;
	
	if (i == 0) {
		i1 = 1;
		i2 = 2;
	} else if (i == 1) {
		i1 = 0;
		i2 = 2;
	} else {
		i1 = 0;
		i2 = 1;
	}
	
	if (j == 0) {
		j1 = 1;
		j2 = 2;
	} else if (j == 1) {
		j1 = 0;
		j2 = 2;
	} else {
		j1 = 0;
		j2 = 1;
	}
	
	// check row
	var r1 = ds_grid_get(global.board, i1, j);
	var r2 = ds_grid_get(global.board, i2, j);
	
	if (r1 != noone && r2 != noone) {
		if (r1.owner == turn && r1.type == type && r2.owner == turn && r2.type == type) {
			return true;
		}
	}
	
	
	// check col
	var c1 = ds_grid_get(global.board, i, j1);
	var c2 = ds_grid_get(global.board, i, j2);
	
	if (c1 != noone && c2 != noone) {
		if (c1.owner == turn && c1.type == type && c2.owner == turn && c2.type == type) {
			return true;
		}
	}
	
	if (!((j == 1 && (i == 0 || i == 2)) || (i == 1 && (j == 0 || j == 2)))) { // if it is not an edge
		// check diagonal
		if (i == 1 && j == 1) {
			// check both diagonals
			var d1 = ds_grid_get(global.board, 0, 0);
			var d2 = ds_grid_get(global.board, 2, 0);
			var d3 = ds_grid_get(global.board, 0, 2);
			var d4 = ds_grid_get(global.board, 2, 2);
			
			if (d1 != noone && d1.owner == turn && d1.type == type && d4 != noone && d4.owner == turn && d4.type == type) {
				return true;	
			} else if (d2 != noone && d2.owner == turn && d2.type = type && d3 != noone && d3.owner == turn && d3.type == type) {
				return true;
			}
			
		} else if (i == j) {
			if (i == 0) { // i and j = 0
				var d4 = ds_grid_get(global.board, 2, 2);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if (d4 != noone && d4.owner == turn && d4.type == type && d5 != noone && d5.owner == turn && d5.type == type) {
					return true;	
				}
				
			} else { // i and j = 2
				var d1 = ds_grid_get(global.board, 0, 0);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if (d1 != noone && d1.owner == turn && d1.type == type && d5 != noone && d5.owner == turn && d5.type == type) {
					return true;	
				}
				
			}
		} else {
			if (i == 0) { // i = 0, j = 2
				var d2 = ds_grid_get(global.board, 2, 0);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if (d2 != noone && d2.owner == turn && d2.type == type && d5 != noone && d5.owner == turn && d5.type == type) {
					return true;	
				}
				
			} else { // i = 2, j = 0
				var d3 = ds_grid_get(global.board, 0, 2);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if (d3 != noone && d3.owner == turn && d3.type == type && d5 != noone && d5.owner == turn && d5.type == type) {
					return true;	
				}
				
			}
		}
	}
	
	return false;

}

function countTwos(i, j, type, turn) {
	
	count = 0;
	
	var i1, i2, j1, j2;
	
	if (i == 0) {
		i1 = 1;
		i2 = 2;
	} else if (i == 1) {
		i1 = 0;
		i2 = 2;
	} else {
		i1 = 0;
		i2 = 1;
	}
	
	if (j == 0) {
		j1 = 1;
		j2 = 2;
	} else if (j == 1) {
		j1 = 0;
		j2 = 2;
	} else {
		j1 = 0;
		j2 = 1;
	}
	
	// check row
	var r1 = ds_grid_get(global.board, i1, j);
	var r2 = ds_grid_get(global.board, i2, j);
	
	if ((r1 != noone && r1.owner == turn && r1.type == type) || (r2 != noone && r2.owner == turn && r2.type == type)) {
		
		count++;
			
	}
	
	
	// check col
	var c1 = ds_grid_get(global.board, i, j1);
	var c2 = ds_grid_get(global.board, i, j2);
	
	if ((c1 != noone && c1.owner == turn && c1.type == type) || (c2 != noone && c2.owner == turn && c2.type == type)) {
		
		count++;
			
	}
	
	if (!((j == 1 && (i == 0 || i == 2)) || (i == 1 && (j == 0 || j == 2)))) { // if it is not an edge
		// check diagonal
		if (i == 1 && j == 1) {
			// check both diagonals
			var d1 = ds_grid_get(global.board, 0, 0);
			var d2 = ds_grid_get(global.board, 2, 0);
			var d3 = ds_grid_get(global.board, 0, 2);
			var d4 = ds_grid_get(global.board, 2, 2);
			
			if ((d1 != noone && d1.owner == turn && d1.type == type) || (d4 != noone && d4.owner == turn && d4.type == type)) {
				count++;
			} else if ((d2 != noone && d2.owner == turn && d2.type = type) || (d3 != noone && d3.owner == turn && d3.type == type)) {
				count++;
			}
			
		} else if (i == j) {
			if (i == 0) { // i and j = 0
				var d4 = ds_grid_get(global.board, 2, 2);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if ((d4 != noone && d4.owner == turn && d4.type == type) || (d5 != noone && d5.owner == turn && d5.type == type)) {
					count++;
				}
				
			} else { // i and j = 2
				var d1 = ds_grid_get(global.board, 0, 0);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if ((d1 != noone && d1.owner == turn && d1.type == type) || (d5 != noone && d5.owner == turn && d5.type == type)) {
					count++;
				}
				
			}
		} else {
			if (i == 0) { // i = 0, j = 2
				var d2 = ds_grid_get(global.board, 2, 0);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if ((d2 != noone && d2.owner == turn && d2.type == type) || (d5 != noone && d5.owner == turn && d5.type == type)) {
					count++;
				}
				
			} else { // i = 2, j = 0
				var d3 = ds_grid_get(global.board, 0, 2);
				var d5 = ds_grid_get(global.board, 1, 1);
				
				if ((d3 != noone && d3.owner == turn && d3.type == type) || (d5 != noone && d5.owner == turn && d5.type == type)) {
					count++;
				}
				
			}
		}
	}
	
	return count;
}

function cornersTaken() {

	var count = 0;
	
	if (ds_grid_get(global.board, 0, 0) != noone) {
		count++;
	}
	
	if (ds_grid_get(global.board, 2, 0) != noone) {
		count++;	
	}
	
	if (ds_grid_get(global.board, 0, 2) != noone) {
		count++;
	}
	
	if (ds_grid_get(global.board, 2, 2) != noone) {
		count++;	
	}
	
	return count;
}

function getFreeCorner() {

	if (ds_grid_get(global.board, 0, 0) != noone) {
		return 0;
	}
	
	if (ds_grid_get(global.board, 2, 0) != noone) {
		return 1;
	}
	
	if (ds_grid_get(global.board, 0, 2) != noone) {
		return 2;
	}
	
	if (ds_grid_get(global.board, 2, 2) != noone) {
		return 3;
	}

}

function getFreeEdge() {

	if (ds_grid_get(global.board, 1, 0) != noone) {
		return 0;
	}
	
	if (ds_grid_get(global.board, 2, 1) != noone) {
		return 1;
	}
	
	if (ds_grid_get(global.board, 1, 2) != noone) {
		return 2;
	}
	
	if (ds_grid_get(global.board, 0, 1) != noone) {
		return 3;
	}

}