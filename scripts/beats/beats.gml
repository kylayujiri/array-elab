// returns 1 if type1 beats type2
// returns 0 if tie
// returns -1 if type2 beats type1
function beats(type1, type2){
	if (type1 == "rock") {
		if (type2 == "rock") {
			// tie
			return 0;
		} else if (type2 == "paper") {
			// type2 wins
			return -1;
		} else { // type2 is scissors
			// type1 wins
			return 1;
		}
	}  else if (type1 == "paper") {
		if (type2 == "rock") {
			// type1 wins
			return 1;
		} else if (type2 == "paper") {
			// tie
			return 0
		} else { // type2 is scissors
			// type2 wins
			return -1;
		}
	} else { // type1 is scisscors
		if (type2 == "rock") {
			// type2 wins
			return -1;
		} else if (type2 == "paper") {
			// type1 wins
			return 1;
		} else { // type2 is scissors
			// tie
			return 0;
		}
	}
}