import processing.video.*;

import java.util.Scanner;
import java.lang.Thread;

import controlP5.*;

int numPixels;
int[] backgroundPixels;
float[] gradients;
float gradient;
boolean displacementOn;
float coordX;
boolean isVideoPlaying;
ControlP5 cp5;
int picked;
int displacement;
int currB;
String path;
int photoIndex;

Slider s1;

Movie video;

int shiftR;
int shiftG;

void setup() {
    size(490, 360); 
    colorMode(HSB);
    frameRate(30);
    cp5 = new ControlP5(this);
    path = "";
    picked = 0;
    displacement = 0;
    currB = 0;
    isVideoPlaying = false;
    coordX = 0.0;
    displacementOn = true;
    shiftR = 16;
    shiftG = 8;
    photoIndex = 0;
        delay(1000);

    initVideo("alte_zeit.mp4");
    delay(1000);
}

void draw() {
    image(video, 0,0, width, height);
    
    if(video.isPlaying() && video.available()){

      video.loadPixels(); // Make the pixels of video available
      // Difference between the current frame and the stored background
      for (int i = 0; i < numPixels; i++) { 
        coordX =  ((float)(i%width) + 1) / (float) width;
        
        //print("mod: " + coordX + "\n");
        gradients[i] = coordX * 150;

        color currColor = video.pixels[i];
        color bkgdColor = backgroundPixels[i];
      
        int currR = (currColor >> shiftR) & 0xFF;
        int currG = (currColor >> shiftG) & 0xFF;
        if(picked < 0){
           currB = currColor & 0xFF;
        } else {
          currB = (currColor >> picked) & 0xFF;

        }
        // Extract the red, green, and blue components of the background pixel's color
        int backR = (bkgdColor >> 14) & 0xFF;
        int backG = (bkgdColor >> 6) & 0xFF;
        int backB = bkgdColor & 0xFF;


        if(displacementOn){
          //gradient = i%map(mouseX, 0, video.width, 0, 1000);
          if(displacement == 0){
            gradient = 0;
          } else {
            gradient = i%displacement;
          }
        } else {
          //print(String.format("Green: %f\n",gradients[0]));
          gradient = gradients[i];
        }

        float diffR = abs(currR - gradient);
        float diffG = abs(currG - 0);
        float diffB = abs(currB - gradient);
        //print(String.format("Curent Red: %d, Red: %f\n", currR, diffR));

        //print("diff " + i%width + "\n");
        video.pixels[i] = color(diffR, diffG, diffB);
        // The following line does the same thing much faster, but is more technical
        //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
      } 
      video.updatePixels(); // Notify that the pixels[] array has changed
    }
    
}

// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame's pixels into it.
void keyPressed() {
  if(key == 'n'){
    displacementOn = !displacementOn;
    print(String.format("DisplacementOn[%b]. Value: %f\n",  displacementOn, gradient));
  } else if(key == 's'){
    print("Saved!\n");
    saveFrame(String.format("/Users/samantha.lovisolo/Documents/Projects/pole_hope/gradient-%d -####.jpg",photoIndex));
    photoIndex ++;
  } else if(key == 'p'){
    s1 = (Slider)cp5.getController("picked");
    if(s1 == null){
      setupGui("picked", 10, 255);
    }
    if(picked > 0){
      picked = 0;
    }
  }
  if (key == CODED) {
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
  } else if(key == 32 && isVideoPlaying){
        video.pause();
        isVideoPlaying = false;
        print("Video paused"+ "\n");
    } else {
        video.play();
        isVideoPlaying = true;
        print("Video replaying\n\n");
  }
  video.loadPixels();
  arraycopy(video.pixels, backgroundPixels);
}

void movieEvent(Movie video){
  if(video.available()){
    video.read();
    isVideoPlaying = true;
    if(numPixels == 0){
      
    numPixels = video.width * video.height;
    gradients = new float[numPixels];
    backgroundPixels = new int[numPixels];
    }
  } 
}

void initVideo(String path){
    video = new Movie(this,path);

    video.loop();
    video.volume(0);

    setupGui("displacement", 220, 1000);
      
    print(String.format("Video size: %d, pixels: %d\n", video.width * video.height, numPixels));
    // Make the pixels[] array available for direct manipulation
    loadPixels();
}

void setupGui(String name, int posX, int max){
    cp5.addSlider(name)
       .setPosition(posX, 10)
       .setSize(150, 15)
       .setRange(0, max)
       .setValue(150)
       .setColorCaptionLabel(color(20,20,20));
}
