import processing.video.*;
Movie video;
int numPixels;
ArrayList frames;

//different program modes for recording and playback
int mode = 0;
int MODE_NEWBUFFER = 0;
int MODE_RECORDING = 1;
int MODE_PLAYBACK = 2;
int currentX = 0;


void setup()  {
    size(640, 360); 
    colorMode(RGB);
    frameRate(30);
    initVideo("makeamove.mp4");
}

void draw() {
  //image(video, 0,0);
  
  loadPixels();
  
  for (int x = 0; x < video.width -1; x++) { 
    for(int y = 0; y < video.height; y++) {
      pixels[x + y * video.width] = pixels[x + y +1 * video.width];
      //pixels[x + y * video.width] = color(100, 0,0);
    } 
  }
  updatePixels();
}
// ---------------- VIDEO -----------------//

void movieEvent(Movie video){
  if(video.available()){
    video.read();
    video.loadPixels();
  } else {
    print("Video not available\n");  
  }
}

// Video must be in data folder
void initVideo(String path){
    video = new Movie(this,path);
    video.loop();
    video.volume(0);
    numPixels = video.width * video.height;
      
    print(String.format("Video size: %d, pixels: %d\n", video.width, numPixels));
}

// ---------------- EVENTS -----------------//

void keyPressed() {
  if(key == 'r'){
  
  }
}

//
void addToBuffer(){
    PImage img = createImage(width, height, RGB);
   
    arrayCopy(video.pixels, img.pixels);

    frames.add(img);
    
     if (frames.size() >= width) {
      mode = MODE_PLAYBACK;
    }
}
