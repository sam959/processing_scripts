import processing.video.*;

int numPixels;
int[] backgroundPixels;
float[] gradients;
float gradient;
Capture video;
boolean autoGradient;
float coordX;
float oldG;

int shiftR;
int shiftG;

void setup() {
  size(720, 480); 
  colorMode(HSB);
  loadAndStarCamera();
  coordX = 0.0;
  oldG = 0.0;
  autoGradient = true;
  numPixels = video.width * video.height;
  gradients = new float[numPixels];
  shiftR = 16;
  shiftG = 8;
  

  print(String.format("Video size: %d-%d, pixels: %d\n", width, height,numPixels));
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();
}

void draw() {
  if (video.available()) {
    video.read(); 
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
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int backR = (bkgdColor >> 14) & 0xFF;
      int backG = (bkgdColor >> 6) & 0xFF;
      int backB = bkgdColor & 0xFF;

    /*
      float currR = red(currColor);
      float currG = green(currColor);
      float currB = blue(currColor);

      // Extract the red, green, and blue components of the background pixel's color
      float backR = red(bkgdColor);
      float backG = green(bkgdColor);
      float backB = blue(bkgdColor);;
      */
      // Compute the difference of the red, green, and blue gradients
      /*
      float diffR = abs(currR - backR);
      float diffG = abs(currG - backG);
      float diffB = abs(currB - backB);
    */

      if(autoGradient){
        gradient = i%map(mouseX, 0, width, 0, 5000);
        //print("Gradient: " + gradient + "\n");

      } else {
        //print(String.format("Green: %f\n",gradients[0]));
        gradient = gradients[i];
      }


      float diffR = abs(currR - gradient);
      float diffG = abs(currG - 0);
      float diffB = abs(currB - gradient);
      //print(String.format("Curent Red: %d, Red: %f\n", currR, diffR));
      // Render the difference image to the screen
      //print("diff " + i%width + "\n");
      pixels[i] = color(diffR, diffG, diffB);
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    updatePixels(); // Notify that the pixels[] array has changed
  }
}

// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame's pixels into it.
void keyPressed() {
  if(key == 'n'){
    autoGradient = !autoGradient;
    print(String.format("Autogradient[%b]. Gradient: %f\n",  autoGradient, gradient));
  } else if(key == 's'){
    print("Saved!\n");
    saveFrame("/Users/samanthalovisolo/Documents/projects/stills/gradient-####.jpg");
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
  }


  video.loadPixels();
  arraycopy(video.pixels, backgroundPixels);
}

void loadAndStarCamera(){
  String[] cameras = Capture.list();
  
  if(cameras == null){
     println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, width, height);
  }else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    video = new Capture(this,width, height, cameras[0]);
    video.start();  
  }
}
