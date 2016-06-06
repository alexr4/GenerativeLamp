import controlP5.*;
import java.util.*;
ControlP5 cp5;
Accordion acc;
Slider2D r1, r2;

public void initControl()
{
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  int bh = 40;
  int bw = 250 /2 - 5;
  int margin = 20;
  cp5.addBang("Generate new mesh")
    .setPosition(20, margin)
    .setSize(bw, bh)
    .setTriggerEvent(Bang.RELEASE)
    .setLabel("Generate new mesh")
    ;

  cp5.addBang("Save Mesh")
    .setPosition(20 + bw + 10, margin)
    .setSize(bw, bh)
    .setTriggerEvent(Bang.RELEASE)
    .setLabel("Save Mesh")
    ;

  //Define groups
  Group g1 = cp5.addGroup("Global grid parameters")
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(100)
    ;

  Group g2 = cp5.addGroup("Grid shape parameters")
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(260)
    ;

  Group g3 = cp5.addGroup("Grid deformation parameters")
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(100)
    ;

  Group g4 = cp5.addGroup("Grid extrusion parameters")
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(250)
    ;

  Group g5 = cp5.addGroup("Grid thick parameters")
    .setBackgroundColor(color(0, 64))
    //.setBackgroundHeight(100)
    ;


  //add params
  float y = 10;
  float h = 20;
  cp5.addSlider("Grid Width")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(10, 500)
    .setValue(200);
  ;
  y += h;
  cp5.addSlider("Grid Height")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(10, 199)
    .setValue(190);
  ;
  y += h;
  cp5.addSlider("Resolution")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(4, 40)
    .setValue(20);
  ;

  y = 10;
  int s2dh = 100;
  r1 = cp5.addSlider2D("Repulsor 1")
    .setPosition(10, y)
    .setSize(100, 100)
    .setMinMax(0, 0, getValue("Grid Width"), getValue("Grid Height"))
    .setValue(100, 100)
    .enableCrosshair()
    //.disableCrosshair()
    ;
  y += h + s2dh;
  cp5.addSlider("Noise X")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 1)
    .setValue(random(1));
  ;
  y += h;
  cp5.addSlider("Noise Y")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 1)
    .setValue(random(1));
  ; 
  y += h;
  cp5.addSlider("Noise Z")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 1)
    .setValue(random(1));
  ; 
  y += h;
  cp5.addSlider("Offset X")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 0.1)
    .setValue(random(0.1));
  y += h;
  cp5.addSlider("Offset Y")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 0.1)
    .setValue(random(0.1));
  ; 
  y += h;
  cp5.addSlider("Offset Z")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 0.1)
    .setValue(random(0.1));
  ;

  y = 10;
  int th = 20;
  int tw = 60;
  cp5.addToggle("Plane / Tube")
    .setPosition(10, y)
    .setSize(tw, 20)
    ;
  cp5.addToggle("Smooth / noSmooth")
    .setPosition(10 + tw + 20, y)
    .setSize(tw, 20)
    .setValue(1.0);
  ;
  y += h + th; 
  cp5.addSlider("Smooth Level")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(1, 5)
    .setValue(2);
  ;

  y = 10;
  r2 = cp5.addSlider2D("Repulsor 2")
    .setPosition(10, y)
    .setSize(100, s2dh)
    .setMinMax(0, 0, getValue("Grid Width"), getValue("Grid Height"))
    .setValue(100, 100)
    //.disableCrosshair()
    ;
  y += h + s2dh;
  cp5.addSlider("Extrusion Offset")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 1)
    .setValue(0.25);
  ;
  y += h;
  cp5.addSlider("Extrusion Depth Offset")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 10)
    .setValue(2.25);
  ;  
  y += h;
  cp5.addSlider("Extrusion Rotation")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, PI)
    .setValue(HALF_PI/2)
    ;
  y += h;
  cp5.addSlider("Extrusion easing")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 1)
    .setValue(random(1))
    ;
  y += h;
  cp5.addSlider("Depth easing")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 1)
    .setValue(random(1))
    ;
  y += h;
  cp5.addSlider("Rotation easing")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 1)
    .setValue(random(1))
    ;

  y = 10;
  cp5.addSlider("Thickness")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(1, 20)
    .setValue(2.5)
    ;
  y+= h;
  cp5.addSlider("Pilar Level")
    .setPosition(10, y)
    .setSize(100, 10)
    .setRange(0, 100)
    .setValue(2.5)
    ;

  //Attach to
  attachTo("Grid Width", g1);
  attachTo("Grid Height", g1);
  attachTo("Resolution", g1);

  attachTo("Repulsor 1", g2);
  attachTo("Noise X", g2);
  attachTo("Noise Y", g2);
  attachTo("Noise Z", g2);
  attachTo("Offset X", g2);
  attachTo("Offset Y", g2);
  attachTo("Offset Z", g2);

  attachTo("Plane / Tube", g3);
  attachTo("Smooth / noSmooth", g3);
  attachTo("Smooth Level", g3); 

  attachTo("Repulsor 2", g4);
  attachTo("Extrusion Offset", g4);
  attachTo("Extrusion Depth Offset", g4);
  attachTo("Extrusion Rotation", g4);
  attachTo("Extrusion easing", g4);
  attachTo("Depth easing", g4);
  attachTo("Rotation easing", g4);

  attachTo("Thickness", g5);
  attachTo("Pilar Level", g5);

  //styles

  // create a new accordion
  // add g1, g2, and g3 to the accordion.
  acc = cp5.addAccordion("acc")
    .setPosition(20, margin + bh + margin)
    .setWidth(250)
    .addItem(g1)
    .addItem(g2)
    .addItem(g3)
    .addItem(g4)
    .addItem(g5)
    ;
  acc.open(0, 1, 2, 3, 4);

  // use Accordion.MULTI to allow multiple group 
  // to be open at a time.
  acc.setCollapseMode(Accordion.MULTI);
}
//send to
void attachTo(String theControllerName, Group g) {
  Controller c = cp5.getController(theControllerName);
  c.moveTo(g);
}

//GetValue
float getValue(String theControllerName) {
  Controller c = cp5.getController(theControllerName);
  return (float) c.getValue();
}

PVector getArrayValue(String theControllerName)
{
  Controller c = cp5.getController(theControllerName);
  PVector v = new PVector(c.getArrayValue()[0], c.getArrayValue()[1]);
  return v;
}

// style
void style(String theControllerName) {
  Controller c = cp5.getController(theControllerName);
  // adjust the height of the controller
  c.setHeight(15);

  // add some padding to the caption label background
  c.getCaptionLabel().getStyle().setPadding(4, 4, 3, 4);

  // shift the caption label up by 4px
  c.getCaptionLabel().getStyle().setMargin(-4, 0, 0, 0); 

  // set the background color of the caption label
  c.getCaptionLabel().setColorBackground(color(255, 255, 0));
}

//EVENT
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.getController().getName().equals("Generate new mesh")) {
    updatePlane();
  } else if (theEvent.getController().getName().equals("Save Mesh"))
  {
    Date d = new Date();
    long current = d.getTime()/1000;
    saveOBJ("GenerativeLamp_"+current);
  } else if (theEvent.getController().getName().equals("Grid Width"))
  {

    r1.setMaxX(getValue("Grid Width"));
    r2.setMaxX(getValue("Grid Width"));
  } else if (theEvent.getController().getName().equals("Grid Height"))
  {
    r1.setMaxY(getValue("Grid Height"));
    r2.setMaxY(getValue("Grid Height"));
  } else
  {
    //println("do nothing");
  }
  /*println(
   "## controlEvent / id:"+theEvent.controller().getId()+
   " / name:"+theEvent.controller().getName()+
   " / value:"+theEvent.controller().getValue()
   );*/
}


void updatePlane()
{
  //global
  int w = (int) getValue("Grid Width");
  int h = (int) getValue("Grid Height");
  int r = (int) getValue("Resolution");

  //Grid shape
  if (plane.repulsor1 != getArrayValue("Repulsor 1"))
  {
    plane.initRepulsor1(getArrayValue("Repulsor 1"));
  }
  float nx = getValue("Noise X");
  float ny = getValue("Noise Y");
  float nd = getValue("Noise Z");
  float ox = getValue("Offset X");
  float oy = getValue("Offset Y");
  float od = getValue("Offset Z");


  //grid deformation
  int s = (int) getValue("Smooth Level"); 

  //grid extrusion
  if (plane.repulsor2 != getArrayValue("Repulsor 2"))
  {
    plane.initRepulsor2(getArrayValue("Repulsor 2"));
  }

  float extrusionOffset = getValue("Extrusion Offset");
  float extursionDepthOffset = getValue("Extrusion Depth Offset");
  float theta = getValue("Extrusion Rotation");
  float extrusionEasing = getValue("Extrusion easing");
  float depthEasing = getValue("Depth easing");
  float rotationEasing = getValue("Rotation easing");

  //grid thick
  float thickness = getValue("Thickness");
  float pilarLevel = getValue("Pilar Level");

  plane.updateNoise(nx, ny, nd, ox, oy, od);
  plane.updateExtrusion(extrusionOffset, extursionDepthOffset, theta);
  plane.updateEasing(extrusionEasing, depthEasing, rotationEasing);
  plane.updateThickness(thickness);
  plane.updatePilarLevel(pilarLevel);
  plane.updateRawGrid(w, h, r);
  if (getValue("Smooth / noSmooth") == 1.0)
  {
    // println("Smooth");
    plane.computeSmooth(s);
  } else
  {
    // println("No Smooth");
    plane.updateMesh();
  }
  //plane = new Plane(w, h, r, s);
}