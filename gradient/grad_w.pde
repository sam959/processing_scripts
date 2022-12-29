import processing.video.*;
import controlP5.*;
import java.util.List;

int numPixels;
int[] backgroundPixels;
int[] shiftedColors;
int[] shiftBackColors;
int[] prevPixels;
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
int currR;
int currB;
int currG;
int backR;
int backG;
int  backB;
int ii;
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

int pixel;
int pixPerColumn;
int numberOfPixelsInCol;
int buffCount;
int modBuffer;

boolean toggleDivide;

color originalColor;
color backColor; 
color previousColor;
color buffCol;

Movie video;

int shiftR;
int shiftG;

int mod;

boolean timeMachineActive;
boolean shouldPrint;

float lfoFreq;
float lfoAmplitude;

PImage buffer;

void setup()  {
    size(640, 360); 
    colorMode(RGB);
    frameRate(30);
    cp5 = new ControlP5(this);
    initVideo("pole.mp4");
    shiftedColors = new int[3];
    shiftBackColors = new int[3];
    timeMachineActive = false;
    recordVideo = false;
    buffers = new ArrayList<Integer>(10);
    coordX = 0;
    mod = 0;
    prevIndex = 0;
    threshold = 255;
    coordY = 0;
    ii = 1;
    shiftGradient = 0.0;
    displacement = 0;
    previousColor = 0;
    currR = 0;
    currB = 0;
    currG = 0;
    funLfo = 0.0;
    buffCount = 1;
    modBuffer= 0;
    funDisplacement = 0.0;
    isVideoPlaying = false;
    gradientXcoord = 0.0;
    displacementOn = true;
    shouldPrint = true;
    shiftR = 16;
    shiftG = 8;
    lfoFreq= 0.0;
    lfoAmplitude = 0.0;
    photoprevI = 0;
    lfo = 0.0;
    numberOfPixelsInCol = 0;
    toggleDivide = false;
    buffer = new PImage(width, height);
  
    setupOptions();
    loadPixels();
}

void draw() {
    //image(video, 0,0, width, height);
    loadPixels(); 
    buffer.loadPixels();

    if(isVideoPlaying && frameCount > 0){
    /*
      if(video.pixels != null){
        arrayCopy(video.pixels, prevPixels);
      }
      */

      lfo =  sin(millis()* lfoFreq) * lfoAmplitude;
      
      // ______________ FOR EVERY PIXEL PER FRAME... ______________ //
      for (int i = 0; i < numPixels; i++) { 
        prevIndex = i == 0? 0 : i - 1;

        gradientXcoord =  ((float)(i%width) + 1) / (float) width;
        gradients[i] = gradientXcoord * shiftGradient; 

        coordY = i%height;
        mod = i%4;
      
        // When coordY is zero, it means it's the last of its column before incrementing
        // to next Y coordinate
        if(coordY == 0){
          coordX++;
        }
        if(shiftG > 0 && i%int(shiftG) == 0){
          toggleDivide = !toggleDivide;
        }
        if(toggleDivide){
          funDisplacement = 0;
        } else {
          funDisplacement = i%(displacement);
        }

        /*
        if(frameCount == 2){
          print(String.format("X: %d Y: %d\n", coordX, coordY));
        }
        */
      
      /*
        // If 0, a column has passed
        coordY = i%height;
        if(coordY == 0){
          coordX++;
          // 4 columns of pixels have passed
          if(coordX == height * 4){
              coordX = 0;
              fill(255,200,200);
              rect(0, height, 100, 100);
              print("Freached 4th line\n");

          }
        }
      
        if((frameCount == 2 || frameCount == 3) && shouldPrint){
          print("Number of pixels in column per frame : " + coordX + "\n");
          pixPerColumn = 0;
          if(frameCount == 3){
            shouldPrint = false;
          }
        }
        //print("coordY: " + coordX + "\n");
        */
  
        // ---- Color stuff ----- //

        originalColor = video.pixels[i];
        //buffer.pixels[i] = 0xFF000000 | (originalColor << 16) | (originalColor << 8) | originalColor;

        buffer.pixels[i] = originalColor;
        buffer.updatePixels();
        buffers.add(buffer);
        if(buffers.size() >   10){
          buffers.remove(0);
        }
      
        if(displacementOn){
          //gradient = i%map(mouseX, 0, video.width, 0, 1000);
          if(displacement == 0){
            gradient = 0;
          } else {
            //funDisplacement = i%displacement;
            //funDisplacement = i%(displacement+lfo);
            //funDisplacement = sin(displacement + lfo);
            gradient = funDisplacement;
          }
        } else {
          //print(String.format("Grandients: %f\n",gradients[i]));
          gradient = gradients[i];
        }

        if(timeMachineActive){
    
        /*
          int[] prevRGB = bitShift(prevPixels[i], 16, 8); 
          diffR = abs(prevRGB[0] - gradient);
          diffG = abs(prevRGB[1] + gradient);
          diffB = abs(prevRGB[2] - gradient);
          */
  
          //PImage p = (PImage)buffers.get(buffers.size()- buffCount);
          PImage p = (PImage)buffers.get(buffers.size()- buffCount);

          buffCount++;
          //print(String.format("buffer %d", buffCount));
          if(buffCount == buffers.size()){
            buffCount = 1;
          }
          p.loadPixels();

          //modBuffer = mod%buffCount;
          //modBuffer = i - height < 0? 0 : i - shiftR;
          //print(String.format("Mod: %d,buffer: %d, modBuffer: %d\n", mod,buffCount, modBuffer));
          int m = coordX%height;
          //print(String.format("m %d, buffcount %d, coordX %d\n", m, buffCount, coordX));

          //int v = i * (int) lfoAmplitude;
          
          //modBuffer = v < 0 || v >= p.pixels.length ? 0 : v;p
          //int mult = i + int(lfo * buffCount);
          funLfo = i * int(abs((lfo) * 10) + 1);

          int indexBuffer = int(i < buffCount ? i : funLfo);
          int finalI = indexBuffer > p.pixels.length -1| indexBuffer < 0? p.pixels.length -1 : indexBuffer;
          int mult = i + 50;
          if(mult > p.pixels.length -1){
            mult = p.pixels.length -1;
          } else if(mult < 0){
            mult = 0;
          }
          buffCol = p.pixels[mult];

          int[]buffCols = bitShift(buffCol, 16, 8, 255);
          diffR = abs (buffCols[0] );
          diffG = abs(buffCols[1] );
          diffB = abs(buffCols[2]);
          pixels[i] = color(diffR,   diffG, diffB);

        } else {
        shiftedColors = bitShift(originalColor, shiftR, shiftG, threshold);

          /*
          When doing color = abs(shiftedColors[0] * gradient);
          the operation * is used when the fun displacement is the sine of the lfo,
          the operation +/- is used when the fun diplacement is the mod of the lfo
         
          //Gradients set with 'p' now shift coordXording to lfo
          pixels[i] = toColor(bitShift(originalColor, (int) (shiftR * gradient * lfo) , shiftG));


          pixels[i] = color(
                            abs(shiftedColors[0] + gradient),
                            abs(shiftedColors[1] - gradient),
                            shiftedColors[2]
                            );
                                      */
         
         int in = i;
         PImage im = (PImage) buffers.get(int(random(buffers.size())));
          if(!timeMachineActive){ 
           if(toggleDivide){
             float p = i - sin(millis() * 0.1);
             in = int(constrain(p, 0.0, pixels.length -1));
          
             pixels[i] = im.pixels[in];
            } else {
              pixels[i] = im.pixels[in] - 1;
            } 
           } else {
                   if(toggleDivide){
             float p = i - sin(millis() * 0.1);
             in = int(constrain(p, 0.0, pixels.length -1));
          
             pixels[i] = im.pixels[in];
            } else {
              //pixels[i] = im.pixels[in] - 1;
            } 
           }
         
          //pixels[i] = video.pixels[int(in)];
         
          //print(String.format("H: %d, S: %d, B: %d\n", shiftedColors[0], shiftedColors[1], shiftedColors[2]));
        }
        //pixels[i] = color(prevR, prevG, prevB);
        // The following line does the same thing much faster, but is more technical
        //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
      }
      updatePixels(); // Notify that the pixels[] array has changed
    }

    if(recordVideo){
      saveFrame("rec2/grad-#####.tif");
    }
    
    fill(255, 50, 0);

    text(String.format("ShiftGradient: %f", shiftGradient), 10, 240);
    text("fun lfo: " + funLfo, 10, 260);
    text(String.format("shiftR: %d, shiftG: %d", shiftR, shiftG), 10, 280);
    text(String.format("Lfo: %f", lfo), 10, 300);
    if(timeMachineActive){
      text("Time machine active", 10, 320);
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

// ---------------- EVENTS -----------------//

void keyPressed() {
  if(key == 'n'){
    displacementOn = !displacementOn;
    if(!displacementOn){
      displacement = 0;

      video.loadPixels();
      arrayCopy(video.pixels, backgroundPixels);
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
    backgroundPixels = new int[numPixels];
    prevPixels = new int[numPixels];

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
    .setColorLabels(color(0,0,0))
    .setSize(20, 19)
    .addItem("x", 1);   

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
  if(frameCount > 0){
    timeMachineActive = !timeMachineActive;
  }
  print(String.format("timeMachineActive [%b] at frame [%d]\n", timeMachineActive, frameCount));
}


void R(){
  if(frameCount > 0){
    recordVideo = !recordVideo;
    print(recordVideo? "Recording video\n" : "Stopped recording\n" );
  }
}
