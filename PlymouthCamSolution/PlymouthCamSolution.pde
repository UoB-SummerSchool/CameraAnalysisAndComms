// This program analyses a recording of the Marine Biological Association webcam:
// https://webcam.mba.ac.uk/mjpg/video.mjpg

import processing.video.*;
import processing.sound.*;
import mqtt.*;

MQTTClient mqtt;
Movie movie;
SoundFile alarm;
boolean masking = false;
boolean differencing = false;
boolean notifying = false;
PGraphics currentFrame, previousFrame, analysisFrame;

void setup()
{
  size(700, 400);
  // Match the framerate of the video (which is about 2fps)
  frameRate(2);
  surface.setTitle("1/2/3 Jump  (M)ask  (D)ifferencing  (N)otifying");
  movie = new Movie(this, "video.mp4");
  movie.loop();
  currentFrame = createGraphics(width, height);
  previousFrame = createGraphics(width, height);
  analysisFrame = createGraphics(width, height);
  alarm = new SoundFile(this, "alarm.mp3");
  mqtt = new MQTTClient(this);
  mqtt.connect("mqtt://broker.hivemq.com:1883");
//  mqtt.connect("mqtt://test.mosquitto.org:1883");
//  mqtt.connect("mqtt://public-mqtt-broker.bevywise.com:1883");
}

void draw()
{
  if (movie.available()) {
    movie.read();
    drawMovieOntoFrame(currentFrame);
    if (masking) {
      maskOffImage(currentFrame);
      maskOffImage(previousFrame);
    }
    if (differencing) {
      int changedPixelCount = analyseImage(analysisFrame);
      if((changedPixelCount>50) && (notifying)) {
        alarm.play();
        mqtt.publish("plymouth/birds", ""+int(random(1,5)));
      }
      println("Changed Pixels: " + changedPixelCount);
      drawFrameOntoWindow(analysisFrame);
    }
    else drawFrameOntoWindow(currentFrame);
    // Remember the frame for the next time around
    drawMovieOntoFrame(previousFrame);
  }
}

void maskOffImage(PGraphics frame)
{
  frame.beginDraw();
  frame.noStroke();
  frame.fill(0);
  frame.rect(0, 180, width, 220);
  // Blank out the top of the lighthouse !
  frame.rect(538, 140, 30, 40);
  frame.endDraw();
}

int analyseImage(PGraphics frame)
{
  int pixelCount = 0;
  frame.beginDraw();
  for (int y=0; y<height; y++) {
    for (int x=0; x<width; x++) {
      float currentPixelValue = brightness(currentFrame.get(x,y));
      float previousPixelValue = brightness(previousFrame.get(x,y));
      if(difference(previousPixelValue,currentPixelValue) > 20) {
        frame.stroke(255,80,80); // Bright red
        pixelCount++;
      }
      else frame.stroke(0);
      frame.point(x,y);
    }
  }
  frame.endDraw();
  return pixelCount;
}

float difference(float a, float b)
{
  if (a>b) return a-b;
  else return b-a;
}

void keyPressed()
{
  if (key=='1') movie.jump(29);  // Person on the grass
  if (key=='2') movie.jump(80);  // Flock of birds
  if (key=='3') movie.jump(132); // Red car on the roundabout
  if (key=='m') masking=!masking;
  if (key=='d') differencing=!differencing;
  if (key=='n') notifying=!notifying;
}

void mouseClicked()
{
  println(mouseX + " " + mouseY);
}
