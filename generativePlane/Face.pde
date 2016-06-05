
private class Face
{
  private int index;
  private Point[] vertexList;

  //Thickness
  private float thickness;
  private PVector thick;
  private ArrayList<Face> borderList = new ArrayList<Face>();

  //Extrusion factor
  private boolean extrusion;
  private PVector gravity;
  private float extrusionOffset;
  private ArrayList<Face> faceList;

  Face(int index_, PVector v0, PVector v1, PVector v2)
  {
    initFace(index_, v0, v1, v2);
  }

  private void initFace(int index_, PVector v0, PVector v1, PVector v2)
  {
    index = index_;
    vertexList = new Point[3];   

    //vertex list
    vertexList[0] = new Point(v0);
    vertexList[1] = new Point(v1);
    vertexList[2] = new Point(v2);
  }

  private void initThickBorder(float thickness_)
  {
    thickness = thickness_;
    thick = new PVector(0, 0, -thickness);

    if (isExtruded())
    {
      for (Face f : faceList)
      {
        PVector vA = f.vertexList[0].getPosition();
        PVector vB = f.vertexList[1].getPosition();
        PVector vC = f.vertexList[2].getPosition();

        PVector vA_ = vA.copy().add(thick);
        PVector vB_ = vB.copy().add(thick);
        PVector vC_ = vC.copy().add(thick);

        borderList.add(new Face(0, vA, vB, vA_));
        borderList.add(new Face(1, vA_, vB, vB_));
        borderList.add(new Face(2, vB, vC, vB_));
        borderList.add(new Face(3, vB_, vC, vC_));
        borderList.add(new Face(4, vC, vA, vC_));
        borderList.add(new Face(5, vC_, vA, vA_));

        borderList.add(new Face(borderList.size(), vA_, vB_, vC_));
      }
    }
  }

  private void extrude(float extrusionOffset_)
  {
    extrusion = true;
    faceList = new ArrayList<Face>();
    extrusionOffset = extrusionOffset_;
    defineGravityPoint();
    createExtrudedFace();
  }

  private void defineGravityPoint()
  {
    gravity = new PVector();
    PVector v0 = vertexList[0].getPosition();
    PVector v1 = vertexList[1].getPosition();
    PVector v2 = vertexList[2].getPosition();

    gravity.add(v0).add(v1).add(v2);
    gravity.div(3);
  }

  private void createExtrudedFace()
  {
    faceList = new ArrayList<Face>();
    PVector A = vertexList[0].getPosition();
    PVector B = vertexList[1].getPosition();
    PVector C = vertexList[2].getPosition();

    PVector AB = PVector.sub(B, A).div(2);
    PVector BC = PVector.sub(C, B).div(2);
    PVector CA = PVector.sub(A, C).div(2);

    /*  
     PVector AB = PVector.sub(B, A).div(random(1, 4));
     PVector BC = PVector.sub(C, B).div(random(1, 4));
     PVector CA = PVector.sub(A, C).div(random(1, 4));
     */
    AB.add(A);
    BC.add(B);
    CA.add(C);


    PVector A_ = PVector.sub(PVector.lerp(A, gravity, extrusionOffset), A);
    PVector B_ = PVector.sub(PVector.lerp(B, gravity, extrusionOffset), B);
    PVector C_ = PVector.sub(PVector.lerp(C, gravity, extrusionOffset), C);

    /*
    PVector A_ = PVector.sub(PVector.lerp(A, gravity, extrusionOffset+ random(1 - extrusionOffset)), A);
     PVector B_ = PVector.sub(PVector.lerp(B, gravity, extrusionOffset+ random(1 - extrusionOffset)), B);
     PVector C_ = PVector.sub(PVector.lerp(C, gravity, extrusionOffset+ random(1 - extrusionOffset)), C);
     */
    /*
    A_.rotate((1 - extrusionOffset) * PI);
     B_.rotate((1 - extrusionOffset) * PI);
     C_.rotate((1 - extrusionOffset) * PI);
     */
    A_.add(A);
    B_.add(B);
    C_.add(C);

    A_.z += (1.0 - extrusionOffset) * 10.5;
    B_.z += (1.0 - extrusionOffset) * 10.5;
    C_.z += (1.0 - extrusionOffset) * 10.5;

    faceList.add(new Face(0, A, B, A_));
    faceList.add(new Face(1, A_, B, B_));
    faceList.add(new Face(2, B, C, B_));
    faceList.add(new Face(3, B_, C, C_));
    faceList.add(new Face(4, C, A, C_));
    faceList.add(new Face(5, C_, A, A_));

    /*
     faceList.add(new Face(0, A, AB, A_));
     faceList.add(new Face(1, AB, B, B_));
     faceList.add(new Face(2, B_, B, BC));
     faceList.add(new Face(3, C_, BC, C));
     faceList.add(new Face(4, CA, C_, C));
     faceList.add(new Face(5, A, A_, CA));
     */
  }

  //display
  public void add()
  {
    if (!isExtruded())
    {
      PVector v0 = vertexList[0].getPosition();
      PVector v1 = vertexList[1].getPosition();
      PVector v2 = vertexList[2].getPosition();

      //ceil
      vertex(v0.x, v0.y, v0.z);
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
    } else
    {
      for (Face f : faceList)
      {
        if (f != null)
        {
          f.add();
        }
      }
    }

    //global Border
    for (Face f : borderList)
    {
      if (f != null)
      {
        f.add();
      }
    }
  }

  public void add(PShape m)
  {
    if (!isExtruded())
    {
      PVector v0 = vertexList[0].getPosition();
      PVector v1 = vertexList[1].getPosition();
      PVector v2 = vertexList[2].getPosition();

      //ceil
      m.vertex(v0.x, v0.y, v0.z);
      m.vertex(v1.x, v1.y, v1.z);
      m.vertex(v2.x, v2.y, v2.z);
    } else
    {
      for (Face f : faceList)
      {
        if (f != null)
        {
          f.add(m);
        }
      }
    }

    //global Border
    for (Face f : borderList)
    {
      if (f != null)
      {
        f.add(m);
      }
    }
  }

  //Get
  public boolean isExtruded()
  {
    return extrusion;
  }

  public int getIndex()
  {
    return index;
  }

  public Point[] getVertexList()
  {
    return vertexList;
  }
}