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

void drawMovieOntoFrame(PGraphics frame)
{
  if (frame.pixels != null) {
    frame.beginDraw();
    for (int i=0; i<movie.pixels.length; i++) frame.pixels[i] = movie.pixels[i];
    frame.updatePixels();
    frame.endDraw();
  }
  // Need to do another begin and end to make sure the pixels have loaded
  frame.beginDraw();
  frame.endDraw();
  frame.beginDraw();
}

void drawLiveStreamOntoFrame(PGraphics frame)
{
  if (frame.pixels != null) {
    frame.beginDraw();
    PImage grab = loadImage("http://192.171.163.3/axis-cgi/jpg/image.cgi?camera=1&resolution=700x400", "jpg");
    for (int i=0; i<grab.pixels.length; i++) frame.pixels[i] = grab.pixels[i];
    frame.updatePixels();
    frame.endDraw();
  }
  // Need to do another begin and end to make sure the pixels have loaded
  frame.beginDraw();
  frame.endDraw();
  frame.beginDraw();
}

void messageReceived(String topic, byte[] payload)
{
}

void clientConnected()
{
  println("Connected to broker for sending");
}
