PShape shape;
float figureRadius;
float figureSeparation;
int nVertex;
int nFigures;

void setup(){
  size(640, 648, P3D);
  colorMode(HSB);
  background(0);
  shape = createShape();
  figureRadius = 10;
  nFigures = 10;
  nVertex = 10;
  figureRadius = width * 0.25;
  figureSeparation = width * 0.089;
}

void draw(){
    
  for (int j = 0; j < nFigures; j++) { 
    pushMatrix();
    translate(height/ 2, width /2);
    //rotate(PI/60 * j);  
    float transZ = (millis()%360) * 0.5;
    translate(0, 0,transZ);
    print(String.format("transZ is: %f\n", transZ));
    drawFigure(); 
    popMatrix();
  }
  
}

void drawFigure() {
  float r = sin(millis()) * 50;
  shape.setFill(color(random(100,255), 150, 200));
  shape.beginShape();
  for (int i = 0; i < nVertex; i++) {
    float x = figureRadius * cos(TWO_PI/nVertex*i);
    float y = figureRadius * sin(TWO_PI/nVertex*i);
    shape.vertex(x, y);
  }
  shape.endShape(CLOSE);   
  shape(shape, 0,0);
 
}
