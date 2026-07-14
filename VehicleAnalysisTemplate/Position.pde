class Position
{
  int x;
  int y;
  
  public Position(int x, int y)
  {
    this.x=x;
    this.y=y;
  }
  
  String toString()
  {
    return x + "," + y;
  }
  
  int distanceTo(Position distination)
  {
    return int(sqrt(pow(this.x-distination.x,2) + pow(this.y-distination.y,2)));
  }
}
