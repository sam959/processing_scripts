import controlP5.*;
ControlP5 cp5;
PShader shader;
float frequency;
float offset;
float angularVelocity = 0;

void setup(){
  size(480, 480, P2D);
  background(0);

  frameRate(30);
  addUi();
 
  frequency = 100;
  offset = 0;
 
  shader = loadShader("shader1.frag", "shader1.vert");
}

void draw(){
  calculateWave();
  renderShader();
}

void calculateWave(){
  angularVelocity += 0.02;
}

void renderShader(){
  shader.set("frequency", frequency);
  shader.set("angularVelocity", angularVelocity);
  
  shader(shader);
  rect(0.0, 0.0,640.0,480.0);
}

void addUi(){ 
  cp5 = new ControlP5(this);

  cp5.addSlider("frequency")
       .setPosition(10, 10)
       .setSize(150, 10)
       .setRange(0, 100)
       .setValue(100)
       .setColorCaptionLabel(color(20,20,20));
       
  cp5.addSlider("offset")
       .setPosition(200, 10)
       .setSize(150, 10)
       .setRange(0.0, 1.0)
       .setValue(0.0)
       .setColorCaptionLabel(color(20,20,20));
}
