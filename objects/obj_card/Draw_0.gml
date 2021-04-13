// movement

var x_diff = abs(target_x - x);
var y_diff = abs(target_y - y);

if (x_diff > 1) {
	
	x = lerp(x, target_x, 0.2);
	
} else {
	// snap
	x = target_x;
	
}

if (y_diff > 1) {
	
	y = lerp(y, target_y, 0.2);
	
} else {
	// snap
	y = target_y;
	
}

depth = target_depth;


// draw the card

switch (type) {
	case "rock":
		sprite_index = spr_rock;
		break;
	case "paper":
		sprite_index = spr_paper;
		break;
	case "scissors":
		sprite_index = spr_scissors;
		break;
}

if (face_down) sprite_index = spr_cardBack;

draw_sprite(sprite_index, image_index, x, y);