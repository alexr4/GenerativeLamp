import nervoussystem.obj.*;
boolean record;

PShape lamp;

import peasy.*;
PeasyCam cam;

Plane plane;

void setup()
{
  size(1280, 720, P3D); 
  smooth(8);
  appParameter();
  lamp = loadShape("bulb-simple.obj");
  plane = new Plane(200, 200, 10, 2);


  //peasyCam
  cam = new PeasyCam(this, 0, 0, 0, 250);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
}

void draw()
{
  background(50);
  //lights();
  pushMatrix();
  float eta = radians(frameCount * 0.1);
  translate(cos(eta) * 200, 0, sin(eta) * 200);
  //pointLight(255, 255, 255, 0, -0, 0);
  popMatrix();


  pointLight(255, 255, 255, 500, -500, 500);

  drawAxis(40, "RVB");
  /*  pushMatrix();
   translate((float) plane.gridWidth/2.0 * -1.0, (float) plane.gridHeight/2.0 * -1.0, 30);
   rotateY(HALF_PI);
   rotateX(-HALF_PI/2);
   drawAxis(40, "RVB");
   shape(lamp);
   popMatrix();*/

  pushMatrix();
  translate((float) plane.gridWidth/2.0 * -1.0, (float) plane.gridHeight/2.0 * -1.0, 0);
 // translate(0, 0, 65);
  shape(plane.getPlaneShape());
  popMatrix();


  if (record) {
    beginRecord("nervoussystem.obj.OBJExport", "generativeLamp_"+frameCount+".obj");
    plane.record();
    endRecord();
    record = false;
  }

  cam.beginHUD();
  noLights();
  showDebug();
  cam.endHUD();
}

void keyPressed()
{
  if (key == 'r') {
    record = true;
  }

  if (key == 'u')
  {
    plane = new Plane(200, 200, 10, 2);
  }
}