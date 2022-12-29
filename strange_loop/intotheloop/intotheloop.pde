import processing.video.*;

Movie video;
Capture cam;
PShader shader;
PImage image;
int w;
int h;
int destinationX;
int destinationY;
float col;
boolean isVideoPlaying;
float duration;
String dur;
boolean canGrow;

void setup(){
 size(640, 480, P2D);
 frameRate(30);
 isVideoPlaying = false;
 w = 0;
 h = 0;
 destinationX = 0;
 destinationY = 0;
 canGrow = true;
 
 col = 0.0;
 image = loadImage("purple-abstract-art-3109807.jpg");
 shader = loadShader("shader1.frag", "shader1.vert");
 video = new Movie(this, "intotheloop.mp4");

 video.loop();
 video.volume(0);
 duration =  video.duration() / 60;
 dur = String.format("%.2f", duration);
 print("Duration: " + dur + "\n");
}


void movieEvent(Movie video){
  if(video.available()){
    video.read();
    isVideoPlaying = true;
   
    w = video.width;
    h = video.height;
  } 
}


void draw(){
  if(isVideoPlaying){
     slitScan();
  } else {
    runShader();
    image(video, 0,0, width, height);
  }
}

void slitScan(){
   /*
    copy(video, w / 2, 0, 1, h, x, 0, 1, h);

src  PImage: an image variable referring to the source image.   
sx  int: X coordinate of the source's upper left corner
sy  int: Y coordinate of the source's upper left corner
sw  int: source image width
sh  int: source image height
dx  int: X coordinate of the destination's upper left corner
dy  int: Y coordinate of the destination's upper left corner
dw  int: destination image width
dh  int: destination image height

    copy(src, sx, sy, sw, sh, dx, dy, dw, dh)
  */
  copy(video, w / 2, 0, 1,h, 
  destinationX, 
  destinationY,
  1, 
  h);
  
  // starts from 0
  destinationX +=1;
  
  if (destinationX > w) {
    destinationX = 0;
  }
  print("abs: " + abs(destinationY) + " H: " + h + "\n");
  if(abs(destinationY) < h && canGrow){
    destinationY +=1;
    canGrow = true; 
  } else if(destinationY > 0){
    canGrow = false;
    destinationY -= 1;
  } else {
    canGrow = true;
  }
  
  print("DestinationY: " + destinationY + "\n");
}


void keyPressed(){
  if(key == 32 && isVideoPlaying){
    video.pause();
    isVideoPlaying = false;
    print("Video paused"+ "\n");
  } else {
    video.play();
    isVideoPlaying = true;
    print("Video replaying\n\n");
  }
}

void runShader(){
  shader.set("col", col);
  shader.set("dispX", col);
  shader.set("dispY", col);
  shader(shader);
  col = map(mouseX, 0, width, 0.0, 1.0);
  print(col + "\n");
}
