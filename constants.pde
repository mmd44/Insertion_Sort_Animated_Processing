final int ARRAY_SIZE = 10;

// Animation Params.
final int DELAY1 = 500;
final int RATE = 60;  // Because need to run a 1 move per second and default fps is 60.


// Animation states.
final int STABLE = 1;
final int MOVEUP = 2;
final int MOVEDOWN = 3;
final int IN_PROGRESS = 4;
final int SWAP = 5;
final int ADJUST_PARAMS = 6;


// Rectangle color statuses.
final int SORTED = 1;
final int SELECTED = 2;
final int COMPARED_TO = 3;
final int NOT_SORTED = 4;
final int END = 5;

// Colors.
final color blackColor = color(0,0,0);
final color whiteColor = color(255,255,255);
final color greyColor = color(127,127,127);
final color greenColor = color(0,100,0);
final color redColor = color(255,0,0);
final color blueColor = color(0,0,255);
final color yellowColor = color(255,204,0);