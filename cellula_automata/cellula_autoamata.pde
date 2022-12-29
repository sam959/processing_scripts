Cellula cellula;
boolean stop;

void setup(){
  size(480,640);
  stop = false;
  cellula = new Cellula();
}

void draw(){
  if(!stop){
    /*
    cellula.generate();
    cellula.drawGeneration();
    */
   
    if(cellula.isLastGeneration()){
      cellula.scrollAndDrawCells();
    } else {
      cellula.fillCells();
    }
  }
}

void mousePressed() {
  if(stop){
  
    point(mouseX, mouseY);
  }
}

void keyPressed(){
  if(key == 32){
    stop = !stop;
  }
}
