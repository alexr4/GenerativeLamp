class Face
{
  private int index;
  private PVector[] vertexList;
  private PVector[] innerVertexList;
  private PVector[] innerDifferenceVertexList;


  Face(int index_, PVector v0, PVector v1, PVector v2)
  {
    initFace(index_, v0, v1, v2, v0, v1, v2);
  }

  Face(int index_, PVector v0, PVector v1, PVector v2, PVector v0_, PVector v1_, PVector v2_)
  {

    initFace(index_, v0, v1, v2, v0_, v1_, v2_);
  }


  //init
  private void initFace(int index_, PVector v0, PVector v1, PVector v2, PVector v0_, PVector v1_, PVector v2_)
  {
    index = index_;
    vertexList = new PVector[3]; 
    innerVertexList = new PVector[3];
    innerDifferenceVertexList = new PVector[3];
    
    constrain(v0);
    constrain(v1);
    constrain(v2);
    constrain(v0_);
    constrain(v1_);
    constrain(v2_);

    //vertex list
    vertexList[0] = v0.copy();
    vertexList[1] = v1.copy();
    vertexList[2] = v2.copy();

    innerVertexList[0] = v0_.copy();
    innerVertexList[1] = v1_.copy();
    innerVertexList[2] = v2_.copy();

    innerDifferenceVertexList[0] = PVector.sub(vertexList[0], innerVertexList[0]);
    innerDifferenceVertexList[1] = PVector.sub(vertexList[1], innerVertexList[1]);
    innerDifferenceVertexList[2] = PVector.sub(vertexList[2], innerVertexList[2]);
    
   
  }
  
  private void constrain(PVector v)
  {
    if(v.z <=0)
    {
      v.z = 0;
    }
  }

  //display
  public void add()
  {
    PVector v0 = vertexList[0];
    PVector v1 = vertexList[1];
    PVector v2 = vertexList[2];

    //ceil
    vertex(v0.x, v0.y, v0.z);
    vertex(v1.x, v1.y, v1.z);
    vertex(v2.x, v2.y, v2.z);
  }

  public void add2D()
  {
    PVector v0 = vertexList[0];
    PVector v1 = vertexList[1];
    PVector v2 = vertexList[2];

    //ceil
    vertex(v0.x, v0.y);
    vertex(v1.x, v1.y);
    vertex(v2.x, v2.y);
  }

  public void add(PShape m)
  {
    PVector v0 = vertexList[0];
    PVector v1 = vertexList[1];
    PVector v2 = vertexList[2];

    //ceil
    //m.fill(255, 0, 0);
    m.vertex(v0.x, v0.y, v0.z);
    //m.fill(0, 255, 0);
    m.vertex(v1.x, v1.y, v1.z);
    // m.fill(0, 0, 255);
    m.vertex(v2.x, v2.y, v2.z);
  }

  public void add2D(PShape m)
  {
    PVector v0 = vertexList[0];
    PVector v1 = vertexList[1];
    PVector v2 = vertexList[2];

    //ceil
    m.vertex(v0.x, v0.y);
    m.vertex(v1.x, v1.y);
    m.vertex(v2.x, v2.y);
  }
}