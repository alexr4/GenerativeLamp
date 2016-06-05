class Plane
{
  //Global
  private int gridWidth, gridHeight;
  private int smoothLevel;
  private int resolution;
  private PVector center;
  private float hypotenuse;

  //Vertex & Poly Components
  private PVector repulsor1; 
  private PVector repulsor2; 
  private PVector[][] rawVertList;
  private PVector[][] centroidList;
  private ArrayList<Poly> polyList; //1 poly = 1 grid element
  private int polyListColsLength;
  private float polyExtrusionOffset = 0.25;
  private float polyExtrusionDepthOffset = 2.5;
  private float polyExtrusionRotation = HALF_PI/2;
  private float polyThickness = 2.5;
  private float extrusionEasing = 1.0;
  private float depthEasing = 1.0;
  private float rotationEasing = 1.0;

  //print step
  private float pilarLevel = 10;

  //Noise Shape
  private float nx;
  private float ox;
  private float ny;
  private float oy;
  private float offset;
  private float nd;
  private float od;
  private float marginx;
  private float marginy;
  private int multDepth;

  //Shape
  private PShape pointcloud;
  private PShape wireframe;
  private PShape mesh;


  Plane()
  {
    init(200, 200, 5, 4);
  }

  Plane(int gridWidth_, int gridHeight_, int resolution_, int smooth_)
  {
    init(gridWidth_, gridHeight_, resolution_, smooth_);
  }

  //Init & Compute
  private void init(int gridWidth_, int gridHeight_, int resolution_, int smooth_)
  {
    println("Init new Mesh");

    initGridParameters(gridWidth_, gridHeight_, resolution_);
    initRepulsor1(new PVector(gridWidth/2, gridHeight/4));
    initRepulsor2(new PVector(gridWidth/2, gridHeight/2));
    defineSmoothLevel(smooth_);
    initNoiseShape();
    initRawGrid();
    computeCentroidIteration(rawVertList, smoothLevel);
    initPolyList(centroidList);
    initPointCloudShape(centroidList);
    init2DWireframe();
    initMesh();
    println("New Mesh computed");
  }

  private void initGridParameters(int gridWidth_, int gridHeight_, int resolution_)
  {
    println("\tInit grid parameters");

    gridWidth = gridWidth_;
    gridHeight = gridHeight_;
    resolution = resolution_;

    center = new PVector(gridWidth/2, gridHeight/2);
    hypotenuse = sqrt(pow(gridWidth, 2) + pow(gridHeight, 2));

    rawVertList = new PVector[(gridWidth/resolution) + 1][(gridHeight/resolution) + 1];
    centroidList = new PVector[(gridWidth/resolution) + 1][(gridHeight/resolution) + 1];
  }

  void initRepulsor1(PVector r)
  {
    repulsor1 = r.copy();
  }

  void initRepulsor2(PVector r)
  {
    repulsor2 = r.copy();
  }

  private void defineSmoothLevel(int l)
  {
    smoothLevel = l;
  }

  private void initNoiseShape()
  {

    nx = random(1);
    ny = random(1);
    nd = random(1);
    ox = random(0.1, 0.75);
    oy = random(0.1, 0.75);
    od = random(0.1, 0.75);


    offset = 100;
    marginx = 0;
    marginy = 0;
    multDepth = 2;
  }

  private void initRawGrid()
  {
    println("\tInit raw grid");


    for (int i=0; i<rawVertList.length; i++)
    {
      float noisey = noise(nx, ny, nd);
      float eta = norm(i, 0, rawVertList.length - 1) * TWO_PI;
      for (int j=0; j<rawVertList[0].length; j++)
      {
        float noisex = noise(nx, ny, nd);//nx);
        if (i == 0 && j ==0)
        {
          marginx = noisex * offset;
          marginy = noisey * offset;
        }
        float x = i * resolution + noisex * offset - marginx;
        float y = j * resolution + noisey * offset - marginy;
        float z = 0;


        float distFromCenter = PVector.dist(new PVector(x, y, z), repulsor1);
        float normDist = norm(distFromCenter, 0, hypotenuse/2);
        float easing = 65 * NormalEasing.inoutSin(normDist) - noise(nd, ny, nx) * offset * multDepth + (offset/(multDepth*2));

        z = z - easing;
        if (i == 0 || i==rawVertList.length-1 || j == 0 || j == rawVertList[0].length-1 || z <= pilarLevel)
        {
          z = 0;
        }
        rawVertList[i][j] = new PVector(x, y, z); 

        nx += ox;
        nd += od;
      }
      ny += oy;
    }
  }

  void computeCentroidIteration(PVector[][] raw, int loop)
  {

    println("\tSmooth ", loop);
    if (loop < 1)
    {
      for (int i=0; i<centroidList.length; i++)
      {
        for (int j=0; j<centroidList[0].length; j++)
        {
          PVector v = centroidList[i][j];

          if (i == 0 || i==centroidList.length-1 || j == 0 || j == centroidList[0].length-1 || v.z < 0)
          {
            v.z = 0;
          }
          centroidList[i][j] = v.copy();
        }
      }
    } else
    {   
      centroidList = getCentroidSmooth(raw);
      loop --;
      computeCentroidIteration(centroidList, loop);
    }
  }

  private void initPolyList(PVector[][] grid)
  {
    println("\tInit poly List");
    polyList = new ArrayList<Poly>();
    polyListColsLength = (grid.length - 1) * 2;

    PVector center = new PVector(gridWidth/2, gridHeight/2);
    for (int i=0; i<grid.length; i++)
    {
      for (int j=0; j<grid[0].length; j++)
      {
        try {
          PVector A = grid[i][j];
          PVector B = grid[i+1][j];
          PVector C = grid[i][j+1];
          PVector D = grid[i+1][j+1];

          Poly ABC = new Poly(i + j * polyListColsLength, A, B, C);
          Poly CBD = new Poly((i +1) + j * polyListColsLength, C, B, D);

          PVector gc = A.copy().add(B).add(C).add(D).div(4);
          float distFromCenter = PVector.dist(gc, repulsor2);
          float extrusionOffset =  polyExtrusionOffset + NormalEasing.inoutSin(norm(distFromCenter, 0, hypotenuse/2)) * extrusionEasing;
          float extrusionDepthOffset = polyExtrusionDepthOffset + (1.0 - NormalEasing.inoutSin(norm(distFromCenter, 0, hypotenuse/2))) * depthEasing;
          float rotationOffset =  polyExtrusionRotation + ((1.0 - NormalEasing.inoutSin(norm(distFromCenter, 0, hypotenuse/2))) * PI) * rotationEasing;
          float thickness = polyThickness;// + norm(distFromCenter, 0, hypotenuse/2) * 10;

          if (i == 0 || i==grid.length-2 || j == 0 || j == grid[0].length-2)
          {       
            ABC.unExtrude();
            CBD.unExtrude();
          }
          else if(A.z == 0 || B.z == 0 || C.z==0)
          {
            ABC.unExtrude();
            
          } else if(C.z == 0 || B.z == 0 || D.z==0)
          {
            CBD.unExtrude();
          }else
          {
            ABC.extrude(extrusionOffset, extrusionDepthOffset, rotationOffset);
            CBD.extrude(extrusionOffset, extrusionDepthOffset, rotationOffset);
          }


          ABC.initThickBorder(thickness, center);
          CBD.initThickBorder(thickness, center);



          polyList.add(ABC);
          polyList.add(CBD);
        }
        catch(Exception e)
        {
        }
      }
    }
  }

  //Create Shape
  private void initPointCloudShape(PVector[][] grid)
  {
    pointcloud = createShape();
    pointcloud.beginShape(POINTS);
    pointcloud.noFill();
    pointcloud.stroke(255, 0, 255);
    for (int i=0; i<grid.length; i++)
    {
      for (int j=0; j<grid[0].length; j++)
      {
        PVector v = grid[i][j];
        pointcloud.vertex(v.x, v.y, v.z);
      }
    }
    pointcloud.endShape();
  }

  private void init2DWireframe()
  {
    wireframe = createShape();
    wireframe.beginShape(TRIANGLES);
    //mesh.fill(255);
    wireframe.noFill();
    wireframe.stroke(255, 0, 255, 127);
    //mesh.noStroke();
    for (Poly p : polyList)
    {
      if (p != null)
      {
        p.add2D(wireframe);
      }
    }
    wireframe.endShape();
  }

  private void initMesh()
  {
    mesh = createShape();
    mesh.beginShape(TRIANGLES);
    mesh.fill(255);
    mesh.stroke(255, 0, 255, 127);
    mesh.noStroke();
    for (Poly p : polyList)
    {
      if (p != null)
      {
        p.add(mesh);
      }
    }
    mesh.endShape();
  }

  //Display
  public void display(String m)
  {
    beginShape(TRIANGLES);
    if (m == "WIREFRAME" || m == "wireframe")
    {
      stroke(255, 0, 255, 127);
      noFill();
      for (Poly p : polyList)
      {
        if (p != null)
        {
          p.add2D();
        }
      }
    } else
    {
      fill(255);
      noStroke();
      for (Poly p : polyList)
      {
        if (p != null)
        {
          p.add();
        }
      }
    }
    endShape();
  }

  //Update
  private void updateMesh(int gridWidth_, int gridHeight_, int resolution_, int smooth_)
  {
    initGridParameters(gridWidth_, gridHeight_, resolution_);
    initRepulsor1(new PVector(gridWidth/2, gridHeight/4));
    initRepulsor2(new PVector(gridWidth/2, gridHeight/2));
    defineSmoothLevel(smooth_);
    computeCentroidIteration(rawVertList, smoothLevel);
  }

  private void updatePilarLevel(float l)
  {
    pilarLevel = l;
  }

  private void updateNoise(float nx_, float ny_, float nd_, float ox_, float oy_, float od_)
  {

    nx = nx_;
    ny = ny_;
    nd = nd_;
    ox = ox_;
    oy = oy_;
    od = od_;

    offset = 100;
    marginx = 0;
    marginy = 0;
    multDepth = 2;
  }

  private void updateThickness(float thickness_)
  {
    polyThickness = thickness_;
  }

  void updateExtrusion(float eo, float ed, float eta)
  {
    polyExtrusionOffset = eo;
    polyExtrusionDepthOffset = ed;
    polyExtrusionRotation = eta;
  }

  void updateEasing(float ee, float de, float re)
  {
    extrusionEasing = ee;
    depthEasing = de;
    rotationEasing = re;
  }

  private void updateRawGrid(int gridWidth_, int gridHeight_, int resolution_)
  {
    initGridParameters(gridWidth_, gridHeight_, resolution_);
    initRawGrid();
  }

  private void computeSmooth(int smooth_)
  {   
    defineSmoothLevel(smooth_);
    computeCentroidIteration(rawVertList, smoothLevel);
    initPolyList(centroidList);
    initPointCloudShape(centroidList);
    init2DWireframe();
    initMesh();
  }

  private void updateMesh()
  {

    initPolyList(rawVertList);
    initPointCloudShape(rawVertList);
    init2DWireframe();
    initMesh();
  }

  //Get
  public PShape getPointcloud()
  {
    return pointcloud;
  }

  public PShape getWireframe()
  {
    return wireframe;
  }

  public PShape getMesh()
  {
    return mesh;
  }
}