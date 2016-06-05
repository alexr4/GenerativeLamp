class Poly
{
  private int index;
  private PVector[] mainVertList;
  private ArrayList<Face> faceList;
  private ArrayList<Face> innerFaceList;
  private ArrayList<Face> borderList;
  private float thickness;
  private PVector thick;
  private boolean extrusion;
  private PVector gravityCenter;
  private float extrusionOffset;
  private float extrusionDepthOffset;
  private float thetaExtrusion;
  private PVector crossabac;

  Poly(int index_, PVector v0, PVector v1, PVector v2)
  {
    initPoly(index_, v0, v1, v2);
  }

  //Init
  private void initPoly(int index_, PVector v0, PVector v1, PVector v2)
  {
    //println("Begin Poly");
    index = index_;
    mainVertList = new PVector[3];
    mainVertList[0] = v0;
    mainVertList[1] = v1;
    mainVertList[2] = v2;
    faceList =  new ArrayList<Face>();
    innerFaceList =  new ArrayList<Face>();
    borderList = new ArrayList<Face>();
  }

  private void extrude(float extrusionOffset_, float extrusionDepthOffset_, float theta_)
  {
    //println("\tExtrusion step");
    extrusion = true;
    extrusionOffset = extrusionOffset_;
    extrusionDepthOffset = extrusionDepthOffset_;
    thetaExtrusion = theta_;
    defineGravityPoint();
    createExtrudedFace();
  }
  
  private void unExtrude()
  {
    PVector A = mainVertList[0];
    PVector B = mainVertList[1];
    PVector C = mainVertList[2];
    PVector vA = A.copy();
    PVector vB = B.copy();
    PVector vC = C.copy();
    vA.z = 0;
    vB.z = 0;
    vC.z = 0;
    
    faceList.add(new Face(faceList.size(), A, B, C));
    faceList.add(new Face(faceList.size(), vA, vB, vC));
  }

  private void defineGravityPoint()
  {
    //println("\t\tCompute Gravity Center");
    gravityCenter = new PVector();
    PVector v0 = mainVertList[0];
    PVector v1 = mainVertList[1];
    PVector v2 = mainVertList[2];

    gravityCenter.add(v0).add(v1).add(v2);
    gravityCenter.div(3);
  }

  private void createExtrudedFace()
  {
    // println("\t\tCompute Extrusion");
    PVector A = mainVertList[0];
    PVector B = mainVertList[1];
    PVector C = mainVertList[2];

    PVector ab = PVector.sub(mainVertList[1], mainVertList[0]);
    PVector ac = PVector.sub(mainVertList[2], mainVertList[0]);

    //find perpendicular vector to the plane
    crossabac = ab.cross(ac); //normal perpendicular vector to face
    crossabac.normalize(); //compute normals
    //crossabac.mult(random(-1, 1)); //invert normals
    crossabac.mult(extrusionDepthOffset);


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

    /*
    PVector A_ = PVector.sub(PVector.lerp(A, gravityCenter, extrusionOffset), A);
     PVector B_ = PVector.sub(PVector.lerp(B, gravityCenter, extrusionOffset), B);
     PVector C_ = PVector.sub(PVector.lerp(C, gravityCenter, extrusionOffset), C);
     */
    /*
    PVector A_ = PVector.sub(PVector.lerp(A, gravityCenter, extrusionOffset+ random(1 - extrusionOffset)), A);
     PVector B_ = PVector.sub(PVector.lerp(B, gravityCenter, extrusionOffset+ random(1 - extrusionOffset)), B);
     PVector C_ = PVector.sub(PVector.lerp(C, gravityCenter, extrusionOffset+ random(1 - extrusionOffset)), C);
     */
    /*
     A_.add(A);
     B_.add(B);
     C_.add(C);
     */


    PVector A_ = PVector.sub(PVector.lerp(A, gravityCenter, extrusionOffset), gravityCenter);
    PVector B_ = PVector.sub(PVector.lerp(B, gravityCenter, extrusionOffset), gravityCenter);
    PVector C_ = PVector.sub(PVector.lerp(C, gravityCenter, extrusionOffset), gravityCenter);

    PVector innerA = A_.copy().add(gravityCenter);
    PVector innerB = B_.copy().add(gravityCenter);
    PVector innerC = C_.copy().add(gravityCenter);

    if (thetaExtrusion != 0)
    {
      A_.rotate(thetaExtrusion);
      B_.rotate(thetaExtrusion);
      C_.rotate(thetaExtrusion);
    }

    A_.add(gravityCenter);
    B_.add(gravityCenter);
    C_.add(gravityCenter);    


    A_.add(crossabac);
    B_.add(crossabac);
    C_.add(crossabac);


    faceList.add(new Face(0, A, B, A_, A, B, innerA));
    faceList.add(new Face(1, A_, B, B_, innerA, B, innerB));
    faceList.add(new Face(2, B, C, B_, B, C, innerB));
    faceList.add(new Face(3, B_, C, C_, innerB, C, innerC));
    faceList.add(new Face(4, C, A, C_, C, A, innerC));
    faceList.add(new Face(5, C_, A, A_, innerC, A, innerA));


    /*faceList.add(new Face(0, A, AB, A_));
     faceList.add(new Face(1, AB, B, B_));
     faceList.add(new Face(2, B_, B, BC));
     faceList.add(new Face(3, C_, BC, C));
     faceList.add(new Face(4, CA, C_, C));
     faceList.add(new Face(5, A, A_, CA));*/
  }

  private void initThickBorder(float thickness_, PVector center_)
  {
    //println("\tThickness step");
    thickness = thickness_;
    thick = new PVector(0, 0, -thickness);

    if (isExtruded())
    {
      for (Face f : faceList)
      {
        PVector vA = f.innerVertexList[0];
        PVector vB = f.innerVertexList[1];
        PVector vC = f.innerVertexList[2];

        PVector cA = PVector.sub(new PVector(vA.x, vA.y), center_).normalize().mult(5);
        PVector cB = PVector.sub(new PVector(vB.x, vC.y), center_).normalize().mult(5);
        PVector cC = PVector.sub(new PVector(vC.x, vC.y), center_).normalize().mult(5);

        PVector vA_ = vA.copy().add(thick);//.add(f.innerDifferenceVertexList[0]);
        PVector vB_ = vB.copy().add(thick);//.add(f.innerDifferenceVertexList[1]);
        PVector vC_ = vC.copy().add(thick);//.add(f.innerDifferenceVertexList[2]);

        if (vA.z <= 0)
        {
          vA_.add(cA);
        }

        if (vB.z <= 0)
        {
          vB_.add(cB);
        }

        if (vC.z <= 0)
        {
          vC_.add(cC);
        }

        innerFaceList.add(new Face(innerFaceList.size(), vA_, vB_, vC_));
      }
    }


    if (isExtruded())
    {
      for (int i=0; i<faceList.size(); i++)
      {
        Face ff = faceList.get(i);
        Face bf = innerFaceList.get(i);
        
        PVector vA = ff.vertexList[0];
        PVector vB = ff.vertexList[1];
        PVector vC = ff.vertexList[2];      

        PVector vA_ = bf.vertexList[0];
        PVector vB_ = bf.vertexList[1];
        PVector vC_ = bf.vertexList[2];

        borderList.add(new Face(0, vA, vB, vA_));
        borderList.add(new Face(1, vA_, vB, vB_));
        borderList.add(new Face(2, vB, vC, vB_));
        borderList.add(new Face(3, vB_, vC, vC_));
        borderList.add(new Face(4, vC, vA, vC_));
        borderList.add(new Face(5, vC_, vA, vA_));
      }
    }
  }

  //display
  public void add()
  {
    for (Face f : faceList)
    {
      if (f != null)
      {
        f.add();
      }
    }

    for (Face f : innerFaceList)
    {
      if (f != null)
      {
        f.add();
      }
    }
    for (Face f : borderList)
    {
      if (f != null)
      {
        f.add();
      }
    }
  }

  public void add2D()
  {
    for (Face f : faceList)
    {
      if (f != null)
      {
        f.add2D();
      }
    }

    for (Face f : innerFaceList)
    {
      if (f != null)
      {
        f.add2D();
      }
    }
    for (Face f : borderList)
    {
      if (f != null)
      {
        f.add2D();
      }
    }
  }

  public void add(PShape m)
  {
    for (Face f : faceList)
    {
      if (f != null)
      {
        f.add(m);
      }
    }
    for (Face f : innerFaceList)
    {
      if (f != null)
      {
        f.add(m);
      }
    }
    for (Face f : borderList)
    {
      if (f != null)
      {
        f.add(m);
      }
    }
  }

  public void add2D(PShape m)
  {
    for (Face f : faceList)
    {
      if (f != null)
      {
        f.add2D(m);
      }
    }

    for (Face f : innerFaceList)
    {
      if (f != null)
      {
        f.add(m);
      }
    }
    for (Face f : borderList)
    {
      if (f != null)
      {
        f.add2D(m);
      }
    }
  }

  //get
  public boolean isExtruded()
  {
    return extrusion;
  }

  public int getIndex()
  {
    return index;
  }
}