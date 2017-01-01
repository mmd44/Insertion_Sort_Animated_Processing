InsertSortAnim insertAnim;

void setup()
{
  size(1000, 500);
 
  /* If need to test against specific order.
  int[] rand = new int[10];
  rand[0] =10;
  rand[1] =10;
  rand[2] =10;
  rand[3] =10;
  rand[4] =10;
  rand[5] =10;
  rand[6] =10;
  rand[7] =10;
  rand[8] =10;
  rand[9] =10;*/
  
  MRect[] rectangleArray = new MRect[ARRAY_SIZE];

  for (int i=0; i<ARRAY_SIZE; i++) {
      int randomInt = int (random (100) + 1); // A random int between 1 and 100 inclusive.
      rectangleArray [i]= new MRect(width*0.1 + i*50 + 10*i, 10, randomInt); // Make the initial rectangle postions dependent on the screen width.
  }
  
  insertAnim = new InsertSortAnim (rectangleArray);
  insertAnim.init();
}
 
void draw()
{
  background(0);
  insertAnim.draw();
}




// Custom rectangle class
class MRect 
{
  int w; // Rectangle width.
  float h; // Rectangle height.
  
  float xpos; // Rectangle xposition.
  float ypos ; // Rectangle yposition.
  
  int value; // The integer it is holding.
  
  int status; // To know which color to use.
 
  
  MRect(float ixp, float iyp, int val) {
    w = 50;
    
    h = 0.2*val*10; // Make the height value dependent.
    
    xpos = ixp;
    ypos = iyp;
    
    value = val;
    status = NOT_SORTED;
  }
  
  int getValue () {
    return value;
  }
  
  void drawRect() {
    rect(xpos, ypos, w, h);
    
    fill(whiteColor);
    textAlign(CENTER);
    // Make the value appear at top of rectangle if height is small (value <= 10).
    if (value > 10) {
      text(value,xpos+w*0.5,ypos+0.5*h);
    }else {
      text(value,xpos+w*0.5,ypos + 30);
    }
    
  }
}



class InsertSortAnim {
  
  int[] randomArray;
  MRect[] rectangleArray;
  
  int state;        // State based on which animation progress. All states can be seen in the "constants" seperate file. Initialized at STABLE
  
  int cursor;       // The array index of the element pulled down (extracted). Initialized at 1.
  int comparedTo;   // The array index of the element we are comparing to. Initialized at "cursor".
  
  float horizontalMove;
  float verticalMove;
  
  int size;         // Array size.
  
  int rateCount;    // Used to animate movements.

  boolean delayBeforeShift; // Used to delay before shifts begin (better user experience).
  
  InsertSortAnim (MRect[] rectangleArray) {
    this.rectangleArray = rectangleArray; 
    
    state = STABLE;   
    
    size = ARRAY_SIZE;
    
    horizontalMove = rectangleArray[1].w + 10;
    verticalMove = height/2;
    
    cursor = 1;
    comparedTo = cursor;
    
    rateCount = 0;
    
    delayBeforeShift = true;
  }
  
  void draw(){
   
    switch(state){
      case STABLE:
        drawInit(); break;
      case MOVEDOWN:
        shiftDown(); break;
      case MOVEUP:
        shiftUp (); break;
      case SWAP:
        shiftLeftRight(); break;
      case IN_PROGRESS:
        checkIfSwap(); break;
      case ADJUST_PARAMS:
         adjustParams(); break;    
    }
  }
  
  /*
   * Function that draws the rectangle and colors them based on their status.
   **/
  void drawInit () {
    for (int i=0; i<rectangleArray.length; i++) {
      color c = greyColor;
      switch(rectangleArray[i].status){
        case SELECTED:
          c = redColor; break;
        case SORTED:
          c = yellowColor; break;
        case COMPARED_TO:
          c = greenColor; break;
        case NOT_SORTED:
          c = greyColor; break;
        case END:
          c = blueColor; break;
      }
      fill (c);
      rectangleArray[i].drawRect();
    }
  }
  
  
  /*
   * Function that extract down a rectangle from the array.
   **/
  void shiftDown () {
    drawInit();
    
    rectangleArray[cursor].status = SELECTED;
    
    if (rateCount < RATE) {
      rectangleArray[cursor].ypos += verticalMove/RATE;
      rateCount++;
    }
    else {
      rateCount = 0;
      state = IN_PROGRESS;
      rectangleArray[comparedTo-1].status = COMPARED_TO;
    }
    
  }
  
  /*
   * Function that shifts up a rectangle back to the array.
   **/
  void shiftUp () {
    drawInit();      
    
    if (delayBeforeShift) {
       delay(DELAY1);
     }
    
    if (rateCount < RATE) {
      rectangleArray[cursor].ypos -= verticalMove/RATE;
      rateCount++;
      delayBeforeShift = false;
    }
    else {
      delayBeforeShift = true;
      rateCount = 0;
      state = ADJUST_PARAMS;
      
      rectangleArray[cursor].status = SORTED;
      
      if (comparedTo -1 >= 0 && comparedTo-1 < size) 
        rectangleArray[comparedTo-1].status = SORTED;
    }
  }
  
  
  /*
   * Function that checks if two rectangles need to be swaped and switch states appropriately.
   **/
  void checkIfSwap () {
    drawInit ();
    if (comparedTo == 0) 
      state = MOVEUP;
    else if (rectangleArray[comparedTo - 1].getValue() > rectangleArray[cursor].getValue()) 
      state = SWAP;
    else  
     state = MOVEUP;
  }
 
  /*
   * Function that swaps two rectangles (one is down, the other is up in the array).
   **/
  void shiftLeftRight () {    
     drawInit();
    
     if (delayBeforeShift) {
       delay(DELAY1);
     }
    
     if (rateCount < RATE) {
        rectangleArray[cursor].xpos -= horizontalMove/RATE;
        rectangleArray[comparedTo-1].xpos += horizontalMove/RATE;
        rateCount++;
        delayBeforeShift = false;
      } else {
        rateCount = 0;
        delayBeforeShift = true;
       
        delay (DELAY1); // Optional delay.
        
        rectangleArray[comparedTo-1].status = SORTED; // Set sorted color after comparision is done.
    
        comparedTo--; // Decrement comparedTo value for next iteration.
        
        if (comparedTo != 0) // May be 0 if the number at cursor is compared with the first element; cursor reached the begining of the array.
          rectangleArray[comparedTo-1].status = COMPARED_TO; // Set sorted color for next comparision.
        
        state = IN_PROGRESS; 
      }
  }
  
  /*
   * Function that initiaizes the animation, need to mark the "zero" element as sorted and start pulling down number at index "Cursor" (first iteration).
   **/
  void init () {
    rectangleArray[0].status = SORTED;
    state = MOVEDOWN;
  }
  
  /*
   * Function that adjust the parameters (cursor, comparedTo, and colors) after each "cursor" iteration and prepares them for the next one. It also check for the end condition.
   **/
  void adjustParams () {
    drawInit();
    //End Condition
    if (cursor == size - 1) {
      state = STABLE;
      
      for (int i = 0; i< size; i++)
        rectangleArray[i].status = END;
      
      println ("END!!!");
    }
    else {
      // This loop is where the algorithm is being applied! the array is being rearranged after the comparision of an element is done.
      for (int i=0; i < cursor - comparedTo; i++) {
        MRect temp = rectangleArray[cursor - i]; 
        rectangleArray[cursor - i] = rectangleArray[cursor - i - 1];
        rectangleArray[cursor - i - 1] = temp;
      }
   
      cursor++;
      comparedTo = cursor;
      state = MOVEDOWN;
    }
  }
}