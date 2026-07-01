boolean connectedToBroker = false;

String videoFolder;
int videoFrameNumber = 1;

void loadVideo(String foldername)
{
  videoFolder = foldername;
  videoFrameNumber = 1;
}

void drawFrameOntoWindow(PGraphics frame)
{
  while(tryToEndDraw(frame));
  image(frame, 0, 0);
}

boolean tryToEndDraw(PGraphics frame)
{
  try {
    frame.beginDraw();
    frame.endDraw();
    return false;
  } catch(Exception e) {
    return true;
  }
}

PGraphics createNewFrame()
{
  PGraphics newFrame = createGraphics(width,height);
  drawMovieOntoFrame(newFrame);
  return newFrame;
}

void drawMovieOntoFrame(PGraphics frame)
{
  String paddedNumber = "" + videoFrameNumber;
  while(paddedNumber.length()<4) paddedNumber = "0" + paddedNumber;
  String fullFilename = sketchPath("data" + File.separator + videoFolder + File.separator + paddedNumber + ".jpg");
  if((new File(fullFilename)).exists()) {
    PImage image = loadImage(fullFilename);
    drawImageOntoFrame(image, frame);
    videoFrameNumber++;
  }
  else videoFrameNumber = 1;
}

void drawLiveStreamOntoFrame(PGraphics frame)
{
  PImage image = loadImage("http://192.171.163.3/axis-cgi/jpg/image.cgi?camera=1&resolution=700x400", "jpg");
  drawImageOntoFrame(image, frame);
}

void drawImageOntoFrame(PImage image, PGraphics frame)
{
  if (frame.pixels != null) {
    frame.beginDraw();
    for (int i=0; i<image.pixels.length; i++) frame.pixels[i] = image.pixels[i];
    frame.updatePixels();
    frame.endDraw();
  }
  // Need to do another begin and end to make sure the pixels have loaded
  frame.beginDraw();
  frame.endDraw();
  frame.beginDraw();
}

void jumpTo(int seconds)
{
  // There are two frames per second
  videoFrameNumber = seconds*2;
}

void messageReceived(String topic, byte[] payload)
{
}

void clientConnected()
{
  connectedToBroker = true;
  println("Connected to broker for sending");
}
