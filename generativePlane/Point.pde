class Point
{
  PVector pos;

  Point(PVector pos_)
  {
    init(pos_);
  }

  private void init(PVector pos_)
  {
    pos = pos_.copy();
  }

  //set
  void setPoint(PVector l)
  {
    pos = l.copy();
  }

  //get
  PVector getPosition()
  {
    return pos.copy();
  }
}