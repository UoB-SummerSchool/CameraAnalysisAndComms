for (int y=0; y<height; y++) {
  for (int x=0; x<width; x++) {
    int pixelColour = currentFrame.get(x, y);
    float pixelHue = hue(pixelColour);
    float pixelSaturation = saturation(pixelColour);
    float pixelBrightness = brightness(pixelColour);
    // If the pixel is in the red range...
    if ((pixelHue>230) && (pixelSaturation>150) && (pixelBrightness>70)) {
      currentFrame.stroke(255, 0, 0);
      currentFrame.point(x, y);
    }
  }
}
