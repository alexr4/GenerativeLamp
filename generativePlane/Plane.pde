//FIND CENTER SHAPE

private class Plane
{
  ///global
  private int smooth;
  private int gridWidth;
  private int gridHeight;
  private int resolution;
  private PVector center;
  private float hypotenuse;

  //component
  private PVector[][] rawVertList;
  private PVector[][] centroidList;
  private Point[][] gridPointList;
  private ArrayList<Face> faceList;
  private int faceListColsLength;

  //PSHAPE
  private PShape pointCloud;
  private PShape mesh;

  Plane(int gridWidth_, int gridHeight_, int resolution_, int smooth_)
  {
    init(gridWidth_, gridHeight_, resolution_, smooth_);
  }

  private void init(int gridWidth_, int gridHeight_, int resolution_, int smooth_)
  {
    initRawGridParameters(gridWidth_, gridHeight_, resolution_, smooth_);
    initRawGrid();
    initFaceList();
    initPointCloudShape();
    initShape();
  }

  private void initRawGridParameters(int gridWidth_, int gridHeight_, int resolution_, int smooth_)
  {
    resolution = resolution_;
    gridWidth = gridWidth_;
    gridHeight = gridHeight_;
    smooth = smooth_;

    center = new PVector(gridWidth/2, gridHeight/4);
    hypotenuse = sqrt(pow(gridWidth, 2) + pow(gridHeight, 2));
    // println(hypotenuse);
  }

  private void initRawGrid()
  {

    //Unique PointList
    gridPointList = new Point[gridWidth/resolution + 1][gridHeight/resolution + 1];
    rawVertList = new PVector[gridWidth/resolution + 1][gridHeight/resolution + 1];
    centroidList = new PVector[gridWidth/resolution + 1][gridHeight/resolution + 1];

    float nx = random(1);
    float ox = random(0.1, 0.75);
    float ny = random(1);
    float oy = random(0.1, 0.75);
    float offset = 100;
    float nd = 0;
    float od = random(0.1, 0.75);
    float marginx = 0;
    float marginy = 0;
    int multDepth = 2;

    for (int i=0; i<gridPointList.length; i++)
    {
      float noisey = noise(nx, ny, nd);
      for (int j=0; j<gridPointList.length; j++)
      {
        float noisex = noise(nx, ny, nd);//nx);
        if(i == 0 && j ==0)
        {
          marginx = noisex * offset;
          marginy = noisey * offset;
        }
        
        float x = i * resolution + noisex * offset - marginx;
        float y = j * resolution + noisey * offset - marginy;
        float z = 0;


        float distFromCenter = PVector.dist(new PVector(x, y, z), center);
        float normDist = norm(distFromCenter, 0, hypotenuse/2);
        float easing = 65 * NormalEasing.inoutSin(normDist) - noise(nd, ny, nx) * offset * multDepth + (offset/(multDepth*2));

        rawVertList[i][j] = new PVector(x, y, z - easing); 

        nx += ox;
        nd += od;
      }
      ny += oy;
    }

    computeCentroidIteration(rawVertList, smooth);

    for (int i=0; i<gridPointList.length; i++)
    {
      for (int j=0; j<gridPointList.length; j++)
      {
        gridPointList[i][j] = new Point(centroidList[i][j]);
        //gridPointList[i][j] = new Point(rawVertList[i][j]);
      }
    }
  }

  void computeCentroidIteration(PVector[][] raw, int loop)
  {

    if (loop < 1)
    {
    } else
    {   
      centroidList = getCentroidSmooth(raw);
      loop --;
      computeCentroidIteration(centroidList, loop);
    }
  }

  private void initFaceList()
  {
    faceList = new ArrayList<Face>();
    faceListColsLength = (gridPointList.length - 1) * 2;

    PVector center = new PVector(gridWidth/2, gridHeight/2);
    for (int i=0; i<gridPointList.length; i++)
    {
      for (int j=0; j<gridPointList[0].length; j++)
      {
        try {
          PVector A = gridPointList[i][j].getPosition();
          PVector B = gridPointList[i+1][j].getPosition();
          PVector C = gridPointList[i][j+1].getPosition();
          PVector D = gridPointList[i+1][j+1].getPosition();

          Face ABC = new Face(i + j * faceListColsLength, A, B, C);
          Face CBD = new Face((i +1) + j * faceListColsLength, C, B, D);

          PVector gc = A.copy().add(B).add(C).add(D).div(4);
          float distFromCenter = PVector.dist(gc, center);
          float extrusionOffset = 0.25 + NormalEasing.inoutSin(norm(distFromCenter, 0, hypotenuse/2));
          float thickness = 1;// 2 + norm(distFromCenter, 0, hypotenuse/2) * 10;

          ABC.extrude(extrusionOffset);
          CBD.extrude(extrusionOffset);

          ABC.initThickBorder(thickness);
          CBD.initThickBorder(thickness);

          faceList.add(ABC);
          faceList.add(CBD);
        }
        catch(Exception e)
        {
        }
      }
    }
  }

  private void initPointCloudShape()
  {
    pointCloud = createShape();
    pointCloud.beginShape(POINTS);
    pointCloud.noFill();
    pointCloud.stroke(255, 0, 255);
    for (int i=0; i<gridPointList.length; i++)
    {
      for (int j=0; j<gridPointList[0].length; j++)
      {
        PVector v = gridPointList[i][j].getPosition();
        pointCloud.vertex(v.x, v.y, v.z);
      }
    }
    pointCloud.endShape();
  }

  private void initShape()
  {
    mesh = createShape();
    mesh.beginShape(TRIANGLES);
    mesh.fill(255);
    mesh.stroke(255, 0, 255, 127);
    mesh.noStroke();
    for (Face f : faceList)
    {
      if (f != null)
      {
        f.add(mesh);
      }
    }
    mesh.endShape();
  }

  public void record()
  {
    beginShape(TRIANGLES);
    fill(255);
    ;
    noStroke();
    for (Face f : faceList)
    {
      if (f != null)
      {
        f.add();
      }
    }
    endShape();
  }

  //get
  public PShape getPointCloudShape()
  {
    return pointCloud;
  }


  public PShape getPlaneShape()
  {
    return mesh;
  }
}