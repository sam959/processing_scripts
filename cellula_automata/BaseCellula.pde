class BaseCellula {

  private boolean endlessOn;
  
  private int[][] generations =  { {0,1}, {0,1}  };
  private int[] cells;
  private int[] ruleset;
  private int cellWidth = 4;
  // y coordinate to continue drawing
  private int generation = 0;
  
  BaseCellula() {
    cells = new int[width/cellWidth];
    // List of cells for all drawn generations
    generations = new int[height/cellWidth][cells.length];
    ruleset = Constants.RULES;
    cells[cells.length / 2] = 1;
    generations[0][cells.length / 2] = 1;
    print(String.format("%d generations with %d cells\n",generations.length, generations[0].length));
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
 
  private int[] generateRuleSet(){
    int random = int(random(2));
    int random2 = int(random(2));
    int random3 = int(random(2));
    int random4 = int(random(2));

    return new int[]{random,random2,random3,random4,random2,random3,random4,random};
  }
}
