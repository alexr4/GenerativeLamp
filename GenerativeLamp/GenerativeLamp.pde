import peasy.*;
import nervoussystem.obj.*;
PeasyCam cam;

PGraphics buffer;
Plane plane;

void setup()
{
  size(1440, 810, P3D);
  //fullScreen(P3D);
  smooth(8);
  appParameter();


  plane = new Plane(200, 200, 20, 2);
  initControl();


  //peasyCam
  cam = new PeasyCam(this, 0, 0, 0, 250);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
}

void draw()
{
  background(50);
  //lights();
  pointLight(255, 255, 255, 500, -500, 500);


  pointLight(100, 100, 100, 0, 0, -200);

  drawAxis(40, "RVB");
  translate(- plane.center.x, -plane.center.y);
  //shape(plane.getPointcloud());
  shape(plane.getMesh());
  //shape(plane.getWireframe());
  //plane.display("wireframe");
  //plane.display("mesh");





  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  noLights();
  cp5.draw();
  showDebug();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void keyPressed()
{
  if (key == 'u')
  {
    plane = new Plane(200, 200, 20, 2);
  }
}

void saveOBJ(String fileName)
{
  beginRecord("nervoussystem.obj.OBJExport", "data/"+fileName+".obj");
  plane.display("mesh");
  endRecord();
}