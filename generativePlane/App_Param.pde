//Sketch properties
String appName = "Generative Lamp";
String version = "Alpha";
String subVersion = "0.0.0";
String frameName;
FPSTracking fpsTracker;

//App Parameters
void appParameter()
{
  frameName = appName+"_"+version+"_"+subVersion;
  surface.setTitle(frameName);
  float w = 100;
  float h = 25;
  fpsTracker = new FPSTracking(floor(w), 60, w, h);
}

void showDebug()
{
  drawAxis(100, "RVB");
  showFpsOnFrameTitle();
  fpsTracker.run(frameRate);
  image(fpsTracker.getImageTracker(), 0, height-fpsTracker.getImageTracker().height);
}

void showFpsOnFrameTitle()
{
  surface.setTitle(frameName+"    FPS : "+int(frameRate));
}

void drawAxis(float l, String colorMode)
{
  color xAxis = color(255, 0, 0);
  color yAxis = color(0, 255, 0);
  color zAxis = color(0, 0, 255);

  if (colorMode == "rvb" || colorMode == "RVB")
  {
    xAxis = color(255, 0, 0);
    yAxis = color(0, 255, 0);
    zAxis = color(0, 0, 255);
  } else if (colorMode == "hsb" || colorMode == "HSB")
  {
    xAxis = color(0, 100, 100);
    yAxis = color(115, 100, 100);
    zAxis = color(215, 100, 100);
  }

  pushStyle();
  strokeWeight(1);
  //x-axis
  stroke(xAxis); 
  line(0, 0, 0, l, 0, 0);
  //y-axis
  stroke(yAxis); 
  line(0, 0, 0, 0, l, 0);
  //z-axis
  stroke(zAxis); 
  line(0, 0, 0, 0, 0, l);
  popStyle();
}

void drawAxis(float l, PVector o, PGraphics buff)
{
  color xAxis = color(255, 0, 0);
  color yAxis = color(0, 255, 0);
  color zAxis = color(0, 0, 255);
  xAxis = color(255, 0, 0);
  yAxis = color(0, 255, 0);
  zAxis = color(0, 0, 255);
  buff.pushStyle();
  buff.strokeWeight(1);
  buff.pushMatrix();
  buff.translate(o.x, o.y, o.z);
  //x-axis
  buff.stroke(xAxis); 
  buff.line(0, 0, 0, l, 0, 0);
  //y-axis
  buff.stroke(yAxis); 
  buff.line(0, 0, 0, 0, l, 0);
  //z-axis
  buff.stroke(zAxis); 
  buff.line(0, 0, 0, 0, 0, l);
  buff.popMatrix();
  buff.popStyle();
}

class FPSTracking
{
  float w, h;
  int nbFrameToTracks;
  float xPositionIncrement;
  ArrayList<PVector> fpsPositionList;
  Timer samplingTimer;
  int samplingTime;
  boolean isConfig;
  PGraphics trackerImage;

  FPSTracking(int nbFrameToTracks_, float samplingTime_, float w_, float h_)
  {
    if (nbFrameToTracks_ > w_)
    {
      println("Please reduce the number of frames to track or increase the width of the display");
    } else
    {
      w = w_;
      h = h_;
      nbFrameToTracks = nbFrameToTracks_;
      xPositionIncrement = w / nbFrameToTracks;
      fpsPositionList = new ArrayList<PVector>();
      samplingTime = floor(1000/samplingTime_);
      samplingTimer = new Timer(samplingTime);
      samplingTimer.start();

      trackerImage = createGraphics(round(w), round(h));

      isConfig = true;
    }
  }

  void run(float frameRateValue)
  {
    if (isConfig)
    {
      if (samplingTimer.isFinished())
      {
        addFrameToHistory(frameRateValue);
        moveFrameOnHistory();
        samplingTimer.start();
      }

      drawShape();

      if (fpsPositionList.size () > 0)
      {
        deleteFrameFromHistory();
      }
    }
  }

  void addFrameToHistory(float frameRateValue)
  {
    float x = w;
    float y = map(frameRateValue, 0, 60, h, 5);
    fpsPositionList.add(new PVector(x, y));
  }

  void deleteFrameFromHistory()
  {
    if (fpsPositionList.size() > nbFrameToTracks)
    {
      fpsPositionList.remove(0);
    }
  }

  void moveFrameOnHistory()
  {
    for (int i=0; i<fpsPositionList.size ()-1; i++)
    {
      PVector nv = fpsPositionList.get(i);
      nv.x -= xPositionIncrement;
      fpsPositionList.set(i, nv);
    }
  }

  void drawShape()
  {
    trackerImage.beginDraw();
    if (fpsPositionList.size () > 0)
    {

      trackerImage.pushStyle();
      trackerImage.background(40);

      trackerImage.beginShape();
      trackerImage.strokeWeight(1);
      trackerImage.stroke(255, 220, 0);
      trackerImage.fill(0, 127);
      trackerImage.vertex(0, h);    
      trackerImage.vertex(0, fpsPositionList.get(0).y);
      for (PVector v : fpsPositionList)
      {
        trackerImage.vertex(v.x, v.y);
      }
      trackerImage.vertex(w, h);
      trackerImage.endShape();


      trackerImage.popStyle();


      trackerImage.pushStyle();
      trackerImage.colorMode(HSB, 360, 100, 100, 100);
      float hue = map(fpsPositionList.get(fpsPositionList.size()-1).y, 5, h, 130, 0);
      float fps = map(fpsPositionList.get(fpsPositionList.size()-1).y, 5, h, 60, 0);
      trackerImage.stroke(hue, 100, 100, 50);
      trackerImage.line(0, fpsPositionList.get(fpsPositionList.size()-1).y, w, fpsPositionList.get(fpsPositionList.size()-1).y);
      trackerImage.fill(hue, 100, 100, 50);
      trackerImage.textAlign(LEFT, TOP);
      trackerImage.text(fps, 10, 10);
      trackerImage.popStyle();
    }


    trackerImage.endDraw();
  }

  void reloadTimer()
  {
    samplingTimer.stop();
    samplingTimer.reset();
    samplingTimer.totalTime = round(samplingTime);
    samplingTimer.start();
  }

  //set
  void setSamplingTime(int value)
  {
    samplingTime = floor(1000/value);
  }

  void setTrackerDimension(float w_, float h_)
  {
    w = w_;
    h = h_;
    xPositionIncrement = w / nbFrameToTracks;
    trackerImage = createGraphics(round(w_), round(h_));
  }

  //get
  PImage getImageTracker()
  {
    return trackerImage;
  }
}

class Timer {

  int savedTime;
  int totalTime;
  int passedTime;
  int remainingTime;
  boolean timerStarted, timerStopped;

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
    timerStarted = false;
    timerStopped = true;
  }

  void start() {
    if (timerStopped) {
      savedTime = millis();
      timerStarted = true;
      timerStopped = false;
    }
  }

  void stop() {
    timerStopped = true;
    timerStarted = false;
  }

  void reset() {
    savedTime = millis();
  }

  boolean isFinished() {
    if (timerStarted) {
      passedTime = millis()- savedTime;
      if (passedTime > totalTime) {
        timerStarted = false;
        timerStopped = true;
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  int getRemainingTime() {
    if (timerStarted) {
      remainingTime = totalTime-passedTime;    
      return remainingTime;
    } else {
      return -1;
    }
  }
}