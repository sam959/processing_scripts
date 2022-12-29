import processing.video.*;
import controlP5.*;
import java.util.List;
import java.util.Arrays;

int numPixels;
int[] shiftedColors;
List buffers;
float[] gradients;
float   gradient;
boolean displacementOn;
float gradientXcoord;
boolean isVideoPlaying;
boolean recordVideo;
ControlP5 cp5;
float shiftGradient;
float displacement;
int threshold;
float diffR;
float diffG;
float diffB;
int photoprevI;
float lfo;
float funLfo;
float funDisplacement;
int coordX;
int coordY;
int prevIndex;
int inc;
int pixPerColumn;
int numberOfPixelsInCol;
int buffCount;
int modBuffer;
int amountToIncrement;

boolean toggleDivide;
boolean effectOn;
boolean invert;

color originalColor;
color previousColor;
color buffCol;

Movie video;

int shiftR;
int shiftG;

int mod;

boolean timeMachineActive;

float lfoFreq;
float lfoAmplitude;

PImage buffer;
Modes mode;

void setup()  {
    size(640, 360); 
    colorMode(RGB);
    frameRate(60);
    mode = Modes.NONE;
    cp5 = new ControlP5(this);
    initVideo("hope.mp4");
    
    shiftedColors = new int[3];
    timeMachineActive = false;
    recordVideo = false;
    buffers = new ArrayList<Integer>(10);
    coordX = 0;
    mod = 0;
    prevIndex = 0;
    threshold = 255;
    coordY = 0;
    shiftGradient = 0.0;
    displacement = 0;
    previousColor = 0;
    funLfo = 0.0;
    buffCount = 1;
    funDisplacement = 0.0;
    isVideoPlaying = false;
    gradientXcoord = 0.0;
    displacementOn = true;
    effectOn = false;
    invert = false;
    shiftR = 16;
    shiftG = 8;
    lfoFreq= 0.0;
    lfoAmplitude = 0.0;
    photoprevI = 0;
    lfo = 0.0;
    inc = 0;  
    amountToIncrement = 1;

    numberOfPixelsInCol = 0;
    toggleDivide = false;
    buffer = new PImage(width, height);
  
    setupOptions();
}

void draw() {

  loadPixels(); 
  buffer.loadPixels();
  
  if(isVideoPlaying && frameCount > 0){
    lfo =  sin(millis()* lfoFreq) * lfoAmplitude;
    PImage im;

    // ______________ FOR EVERY PIXEL PER FRAME... ______________ //
    for (int y = 0; y < video.height; y++) { 
      for (int x = 0; x < video.width; x++) {
        int i = x + y * width;
        originalColor = video.pixels[i];
        //buffer.pixels[i] = 0xFF000000 | (originalColor << 16) | (originalColor << 8) | originalColor;  
        buffer.pixels[i] = originalColor;
        buffer.updatePixels();
        buffers.add(buffer);
        if(buffers.size() >   10){
          buffers.remove(0);
        }
        
          //////////////
       switch(mode){
         case TIME_MACHINE:{}
         break;
         case EFFECT: {}
         break;
         case NONE:  {/* //<>// //<>//
            PImage im;
            if(buffCount == buffers.size()){
              buffCount = 1;
            }
            im = (PImage)buffers.get(buffers.size() -1);             
            im.loadPixels();
            buffCol = im.pixels[i];
           
            int[]buffCols = bitShift(buffCol, 16, 8, 255);
            diffR = abs (buffCols[0] );
            diffG = abs(buffCols[1] );
            diffB = abs(buffCols[2]);
            //pixels[i] = color(diffR,   diffG, diffB);
      
            for(int z = 0; z < 10; z++){ 
              if(x + z < video.width){
              int index = (x + z) + y * width;
                pixels[index] = color(diffR,   diffG, diffB);
              }
            }
        */

            
            buffCount++; 
          }
         break;
       }
    }
    im = (PImage)buffers.get(buffers.size() -1);  
    image(im, 0,0);
    //image(im, width /3, 0);
    //updatePixels(); // Notify that the pixels[] array has changed
    }
    if(recordVideo){
      saveFrame("rec2/grad-#####.tif");
    }
    
    fill(255, 50, 0);
    text(String.format("shiftG: %d", shiftG), 20, 280);
    text(String.format("shiftR: %d", shiftR), 20, 300);
    text(String.format("Lfo: %f", lfo), 20, 380);
    if(timeMachineActive){
      text("Time machine active", 20, 320);
    }
  }
}
// ---------------- PIXELS -----------------//

int[] bitShift(color originalColor, int shiftR, int shiftG, int threshold){
  int r = (originalColor >> shiftR) & 0xFF;
  int g = (originalColor >> shiftG) & threshold;
  int b = originalColor & 0xFF;

  return new int[]{r, g, b};
}

color toColor(int[] colorArray){
  return color(colorArray[0], colorArray[1], colorArray[2]);
}
void displace(int x, int y){

 int i = x + y * video.width; // i = index of grid columns
 float n = warp(x, y, .001, int(displacement)); 
 int offset = i-int(n); //%len; // with a modulo the offset should wrap around 
 if (offset<1){
  offset = 0; 
 }
 if (offset > video.pixels.length /2){
  offset = video.pixels.length -1; 
 }
 if(i%17 == 0){
   
 print(String.format("offset: %d, pixels: %d\n", offset, video.pixels.length));
 }
 color c = video.pixels[offset]; // --> ArrayIndexOutOfBoundsException
 
 pixels[i] = color(c);
   
}

     //<>//
 /**
 *
 * default: warp(x, y, .003, 555);
 */
float warp(int _x, int _y, float factor, int n_range) {
    float n1 = noise((_x+0.0) * factor, (_y+0.0) * factor) * n_range;
    float n2 = noise((_x+5.2) * factor, (_y+1.3) * factor) * n_range;
    PVector q = new PVector(n1, n2);
            
    float n3 = noise(((_x + q.x * 4) + 1.7) * factor, ((_y + q.y * 4) + 9.2) * factor) * n_range;
    float n4 = noise(((_x + q.x * 4) + 8.3) * factor, ((_y + q.y * 4) + 2.8) * factor) * n_range;
    PVector r = new PVector(n3, n4);
                
    return noise((_x + r.x * 4) * factor, (_y + r.y * 4) * factor) * n_range;
}

// ---------------- EVENTS -----------------//

void keyPressed() {
  if(key == 'n'){
    displacementOn = !displacementOn;
    if(!displacementOn){
      displacement = 0;

      video.loadPixels();
    } else {
      shiftGradient = 0.0;
    }
    print(String.format("DisplacementOn[%b]. Value: %f\n",  displacementOn, displacement));
  } else if(key == 's'){
    print("Saved!\n");
    saveFrame(String.format("/Users/samanthalovisolo/Documents/projects/stills/gradient-%d -####.jpg",photoprevI));
    photoprevI ++;
  } else if(key == 'p'){
    if(cp5.getController("shiftGradient") == null){
      addSlider("shiftGradient", 220, 20, 255.0);
    }else if(!cp5.getController("shiftGradient").isVisible()){
      cp5.getController("shiftGradient").show();
    } else {
      cp5.getController("shiftGradient").hide();
    }
    if(shiftGradient > 0){
      shiftGradient = 0;
    }
  } else if (key == CODED) {
    if (keyCode == UP) {
      shiftR++;
    }
    if (keyCode == DOWN) {
      shiftR--;
    }
    if (keyCode == RIGHT) {
      shiftG++;
    }
    if (keyCode == LEFT) {
      shiftG--;
    }
  } else if(key == 32){
    if(isVideoPlaying){
      video.pause();
      isVideoPlaying = false;
      print("Video paused"+ "\n");
    } else {
      video.play();
      isVideoPlaying = true;
      print("Video replaying\n\n");
    }
  }
}

// ---------------- VIDEO -----------------//

void movieEvent(Movie video){
  if(video.available()){
    video.read();
    video.loadPixels();
    isVideoPlaying = true;
  } else {
    print("Video not available\n");  
  }
}

void initVideo(String path){
    video = new Movie(this,path);
    video.loop();
    video.volume(0);

    numPixels = video.width * video.height;
    gradients = new float[numPixels];

    addSlider("displacement", 220, 10, 1000.0);
      
    print(String.format("Video size: %d, pixels: %d\n", video.width, numPixels));
}

// ---------------- GUI -----------------//

void addSlider(String name, int posX, int posY, float max){
    cp5.addSlider(name)
       .setPosition(posX, posY)
       .setSize(150, 10)
       .setRange(0, max)
       .setValue(0.5)
       .setColorCaptionLabel(color(20,20,20));
}
void addSlider(String name, int posX, int posY, float max, float val, color col){
    cp5.addSlider(name)
       .setPosition(posX, posY)
       .setSize(150, 10)
       .setRange(0, max)
       .setValue(val)
       .setColorCaptionLabel(col);
}


void setupOptions(){
    ControlGroup backgroundGuiGroup = cp5.addGroup("LFO",0,10);
    backgroundGuiGroup.setMoveable(true);

    cp5.addButton("X")
    .setValue(1)
    .setPosition(width - 40, 10)
    .setColorBackground(color(125,150,200))
    .setSize(20, 19);  

    cp5.addButton("R")
    .setValue(1)
    .setPosition(width - 20, 10)
    .setColorBackground(color(255,150,200))
    .setSize(20, 19); 

    cp5.addRadioButton("Color")
    .setPosition(width - 20, 30)
    .setColorBackground(color(150,150,200))
    .setSize(20, 19)
    .addItem("x", 1); 
    
    cp5.addButton("FX")
    .setPosition(width - 40, 30)
    .setValue(1)
    .setColorBackground(color(150,200,50))
    .setSize(20, 19);   


    addSlider("lfoFreq", 0, 0, 0.002);
    addSlider("lfoAmplitude", 0, 15, 3.0);
    addSlider("threshold", 0, 40, 255, 255, color(100,100,100));


    cp5.getController("lfoFreq").setGroup("LFO");
    cp5.getController("lfoAmplitude").setGroup("LFO");
}
void controlEvent(ControlEvent theEvent) {

  if (theEvent.isFrom("Color")) {
    print("event from "+theEvent.getName()+"\t");
    for (int i=0; i<theEvent.getGroup().getArrayValue().length; i++) {
      int val = int(theEvent.getGroup().getArrayValue()[i]);
      if(val == 0) {
        colorMode(RGB);
        print("Switched to RGB\n");
      } else if(val == 1) {
        colorMode(HSB);
        print("Switched to HSB\n");
        }
      }
    }
}
void X(){
  if(frameCount > 1){
    if(mode == Modes.TIME_MACHINE){
      mode = Modes.NONE;
    } else {
      
      mode = Modes.TIME_MACHINE;
    }
  }
  print(String.format("Mode:[%s]\n", mode.name()));

}

void FX(){
  if(frameCount > 1){
     if(mode == Modes.EFFECT){
      mode = Modes.NONE;
    } else {
     mode = Modes.EFFECT;
    }
  }
  print(String.format("Mode:[%s]\n", mode.name()));
}


void R(){
  if(frameCount > 0){
    recordVideo = !recordVideo;
    print(recordVideo? "Recording video\n" : "Stopped recording\n" );
  }
}
