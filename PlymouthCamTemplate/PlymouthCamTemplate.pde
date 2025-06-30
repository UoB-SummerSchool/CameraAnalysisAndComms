import processing.video.*;
import mqtt.*;

MQTTClient mqtt;
Movie movie;
PGraphics currentFrame;

void setup()
{
  size(700, 400);
  // Match the framerate of the video (which is about 2fps)
  frameRate(2);
  movie = new Movie(this, "video.mp4");
  movie.loop();
  currentFrame = createGraphics(width, height);
  // Don't worry about these for the time-being, we will use them later !
  // mqtt = new MQTTClient(this);
  // mqtt.connect("mqtt://broker.hivemq.com:1883");
  // mqtt.connect("mqtt://test.mosquitto.org:1883");
  // mqtt.connect("mqtt://public-mqtt-broker.bevywise.com:1883");
}

void draw()
{
  if (movie.available()) {
    movie.read();
    drawMovieOntoFrame(currentFrame);
    // It is essential to "beginDraw" before drawing onto a frame
    currentFrame.beginDraw();
    currentFrame.fill(0);
    currentFrame.noStroke();
    // Mask off the lighthouse
    currentFrame.rect(538, 140, 30, 90);
    for (int y=0; y<height; y++) {
      for (int x=0; x<width; x++) {
        int pixelColour = currentFrame.get(x,y);
        float pixelHue = hue(pixelColour);
        float pixelSaturation = saturation(pixelColour);
        // If the pixel is in the green range...
        if((pixelHue>20) && (pixelHue<70) && (pixelSaturation>100)) {
          // Overwrite the pixel with "concrete grey"
          currentFrame.stroke(180,160,180);
          currentFrame.point(x,y);
        }
      }
    }
  }
  // It is essential to "endDraw" after drawing onto a frame
  currentFrame.endDraw();
  drawFrameOntoWindow(currentFrame);
}

void keyPressed()
{
  if (key=='1') movie.jump(29);  // Person walking on the grass
  if (key=='2') movie.jump(80);  // Flock of birds flying past
  if (key=='3') movie.jump(132); // Red car on the roundabout
}

void mouseClicked()
{
  println(mouseX + " " + mouseY);
}
