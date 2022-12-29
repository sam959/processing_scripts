class Cellula {
  private boolean invert;
  private boolean endless;
  private boolean endlessOn;
  
  private int[][] generations =  { {0,1}, {0,1}  };
  private int[] cells;
  private int[] ruleset;
  private int cellWidth = 4;
  // y coordinate to continue drawing
  private int generation = 0;
  
  Cellula() {
    endless = false;
    endlessOn = false;
    invert = false;
    cells = new int[width/cellWidth];
    // List of cells for all drawn generations
    generations = new int[height/cellWidth][cells.length];
    ruleset = Constants.RULES;
    cells[cells.length / 2] = 1;
    generations[0][cells.length / 2] = 1;
    print(String.format("%d generations with %d cells\n",generations.length, generations[0].length));
  }
  
  private void fillCells(){
    // If is last generation
    if(generation == (height / cellWidth) -1){
      generation = 0; 
    }
    print(String.format("Generation: %d\n",generation)); 
    for(int i  = 0; i < generations.length -2; i++){
      for(int j  = 1; j < generations[generation].length -2; j++){
        int left   = generations[generation][j-1];
        int me     = generations[generation][j];
        int right  = generations[generation][j+1];
        generations[generation + 1][j] = rules(left, me, right); 
      }
    }
    colorCells(generations[generation], generation);
    generation++; 
  }
  
  private void scrollAndDrawCells(){ //<>//
   // Step 1 - Generate the new line from the actual last line
   int[] temp = new int[cells.length];
    for(int i  = 1; i < generations[generations.length - 1].length - 2; i ++){  
      print(String.format("index: %d\n",i)); 
      int left   = generations[generations.length - 1][i-1];
      int me     = generations[generations.length - 1][i];
      int right  = generations[generations.length - 1][i+1];
      temp[i] = rules(left, me, right); 
    }
   
    // Swap every line in the array
    for(int i  = 0; i < generations.length -1 ; i ++){
        generations[i] = generations[i +1];
        // Step 2 - Write over the following line, otherwise it will be the same starting
        // from the next time step 1 is executed 
        generations[i +1] = temp;       
    }
    // Step 3 - Color every line
    for(int i  = 0; i < generations.length; i ++){
      colorCells(generations[i], i); //<>//
    }
   
  }
  
  void generate() {
    int[] nextgen = new int[cells.length];
    for (int i = 1; i < cells.length-1; i++) {
      int left   = cells[i-1];
      int me     = cells[i];
      int right  = cells[i+1];
      nextgen[i] = rules(left, me, right);
    }
    cells = nextgen;
    generations[generation] = nextgen;
    print(String.format("Generation: %d\n",generation));

  }

  private  void drawGeneration(){    
   if(!invert || endless){
      generation++;
    } else if(invert && !endless) {
      generation--;
    } 
    if(generation == (height / cellWidth) -1 || generation == 0 && !endless){
     print("End of screen reached\n");
     setRules(generateRuleSet());
     invert = !invert;
     // Avoid index out of bounds when in endless mode and accessing the array with generations[generation -1][i]
    } 
    if(generation == 0){
      generation = 1;
    }
    if(generation ==(height / cellWidth) -1){
    }
    colorCells(cells, generation);
  }
    
  boolean isLastGeneration(){
    boolean isLast = false;
    int limit = (height / cellWidth) -1;
    if(!endlessOn){
      print(String.format("generation: %d, limit %d\t", generation, limit));
      isLast = generation == limit;
      if(isLast){
         endlessOn = true;
      }
    } else {
      return true;
    }
    print(String.format("endless %b, returning %b\t",endlessOn, isLast));
    return isLast;  
  }
  
  void colorCells(int[]cells, int index) {
    float sin = (sin(millis() * 0.1) + 1);
    
    for (int i = 0; i < cells.length; i++) {
      if (cells[i] == 1){
        // Either black or...
        // Acid green
        //fill(25 * sin, 155, 100 * generation%7);
        // Deep purple 
        //fill(25 * sin, 100 * generation%7, 155);
        // Chromatica ( + Greyish purple, Deep Purple)
        fill(100 + index, 25 * sin, 255);
      } else {
        // Greyish purple
        //fill(100, 100 + sin, 100 + generation);
        // Deep Purple
        //fill(25 * sin, 100 * generation%7, 155);
        // Acid green
        fill(25 * sin, 155, 100 * index%7);
      }
      //Set the y-location according to the generation.
      rect(i*cellWidth, index*cellWidth, cellWidth, cellWidth);
    }
  }
     
   
  int rules(int a, int b, int c) {
    String s = "" + a + b + c;
    int index = Integer.parseInt(s,2);
    return ruleset[index];
  }
  
  void setRules(int[] rules){
    ruleset = rules;
  }
  
  void setCell(){
   cells[cells.length/2] = 1;
  }
 
 void setEndless(boolean endless){
   this.endless = endless;
 }
  private int[] generateRuleSet(){
    int random = int(random(2));
    int random2 = int(random(2));
    int random3 = int(random(2));
    int random4 = int(random(2));

    return new int[]{random,random2,random3,random4,random2,random3,random4,random};
  }
 
  
}
