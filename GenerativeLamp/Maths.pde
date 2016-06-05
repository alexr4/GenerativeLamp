static class NormalEasing
{
  // ==================================================
  // Easing Equations by Robert Penner : http://robertpenner.com/easing/
  // http://www.timotheegroleau.com/Flash/experiments/easing_function_generator.htm
  // Based on ActionScript implementation by gizma : http://gizma.com/easing/
  // Processing implementation by Bonjour, Interactive Lab
  // soit time le temps actuelle ou valeur x à l'instant t;
  // soit start la position x de départ;
  // soit end l'increment de s donnant la position d'arrivee a = s + e;
  // soit duration la durée de l'opération
  // ==================================================
  // Linear
  static float linear(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return inc*time/duration + start;
  }

  // Quadratic
  static float inQuad(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return inc * time * time + start;
  }

  static float outQuad(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return -inc * time * (time - 2) + start;
  }

  static float inoutQuad(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return inc/2 * time * time + start;
    } else
    {
      time--;
      return - inc/2 * (time * (time - 2) - 1) + start;
    }
  }

  //Cubic
  static float inCubic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return inc * pow(time, 3) + start;
  }

  static float outCubic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return inc * (pow(time, 3) + 1) + start;
  }

  static float inoutCubic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return inc/2 * pow(time, 3) + start;
    } else
    {
      time -= 2;
      return inc/2 * (pow(time, 3) + 2) + start;
    }
  }

  //Quatric
  static float inQuartic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return inc * pow(time, 4) + start;
  }

  static float outQuartic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return -inc * (pow(time, 4) - 1) + start;
  }

  static float inoutQuartic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return inc/2 * pow(time, 4) + start;
    } else
    {
      time -= 2;
      return -inc/2 * (pow(time, 4) - 2) + start;
    }
  }

  //Quintic
  static float inQuintic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return inc * pow(time, 5) + start;
  }

  static float outQuintic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return inc * (pow(time, 5) + 1) + start;
  }

  static float inoutQuintic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return inc/2 * pow(time, 5) + start;
    } else
    {
      time -= 2;
      return inc/2 * (pow(time, 5) + 2) + start;
    }
  }

  //Sinusoïdal
  static float inSin(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return -inc * cos(time/duration * HALF_PI) + inc + start;
  }

  static float outSin(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return inc * sin(time/duration * HALF_PI) + start;
  }

  static float inoutSin(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return -inc/2 * (cos(PI * time/duration) - 1) + start;
  }

  //Exponential
  static float inExp(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    //return inc * pow(2, 10 * (time/duration - 1)) + start;
    return inc * pow(2, 10 * (time/duration-1)) + start;
  }

  static float outExp(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return inc * (pow(2, -10 * (time/duration)) * -1) - 1 + start;
  }

  static float inoutExp(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return inc/2 * pow(2, 10 * (time-1)) + start;
    } else
    {
      time --;
      return inc/2 * (-pow(2, -10 * time) + 2) + start;
    }
  }

  //Circular
  static float inCirc(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return -inc * (sqrt(1 - time * time) - 1) + start;
  }

  static float outCirc(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return inc * sqrt(1 - time * time) + start;
  }

  static float inoutCirc(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return -inc/2 * (sqrt(1 - time * time) - 1) + start;
    } else
    {
      time -= 2;
      return inc/2 * (sqrt(1 - time * time) + 1) + start;
    }
  }
}

static class MathsVector
{
  static public PVector computeRodrigueRotation(PVector k, PVector v, float theta)
  {
    // Olinde Rodrigues formula : Vrot = v* cos(theta) + (k x v) * sin(theta) + k * (k . v) * (1 - cos(theta));
    PVector kcrossv = k.cross(v);
    float kdotv = k.dot(v);

    float x = v.x * cos(theta) + kcrossv.x * sin(theta) + k.x * kdotv * (1 - cos(theta));
    float y = v.y * cos(theta) + kcrossv.y * sin(theta) + k.y * kdotv * (1 - cos(theta));
    float z = v.z * cos(theta) + kcrossv.z * sin(theta) + k.z * kdotv * (1 - cos(theta));

    PVector nv = new PVector(x, y, z);
    nv.normalize();

    return  nv;
  }

  static public PVector compute2DRotationVector(PVector k, float eta)
  {
    float x = k.x * cos(eta) - k.y * sin(eta);
    float y = k.x * sin(eta) + k.y * cos(eta);

    return new PVector(x, y);
  }

  static public PVector compute3DRotationVector(PVector k, float eta, char axis)
  {
    /*
  around Z-axis would be
     
     |cos θ   -sin θ   0| |x|   |x cos θ - y sin θ|   |x'|
     |sin θ    cos θ   0| |y| = |x sin θ + y cos θ| = |y'|
     |  0       0      1| |z|   |        z        |   |z'|
     
     around Y-axis would be
     
     | cos θ    0   sin θ| |x|   | x cos θ + z sin θ|   |x'|
     |   0      1       0| |y| = |         y        | = |y'|
     |-sin θ    0   cos θ| |z|   |-x sin θ + z cos θ|   |z'|
     
     around X-axis would be
     
     |1     0           0| |x|   |        x        |   |x'|
     |0   cos θ    -sin θ| |y| = |y cos θ - z sin θ| = |y'|
     |0   sin θ     cos θ| |z|   |y sin θ + z cos θ|   |z'|
     */
    if (axis == 'x' || axis == 'X')
    {
      float x = k.x;
      float y = k.y * cos(eta) - k.z * sin(eta);
      float z = k.y * sin(eta) + k.z * cos(eta);
      PVector v = new PVector(x, y, z);
      v.normalize();

      return v;
    } else if (axis == 'y' || axis == 'Y')
    {
      float x = k.x * cos(eta) + k.z * sin(eta);
      float y = k.y;
      float z = k.x * -1 * sin(eta) + k.z * cos(eta);
      PVector v = new PVector(x, y, z);
      v.normalize();

      return v;
    } else if (axis == 'z' || axis == 'Z')
    {
      float x = k.x * cos(eta) - k.y * sin(eta);
      float y = k.x * sin(eta) + k.y * cos(eta);
      float z = k.z;

      PVector v = new PVector(x, y, z);
      v.normalize();

      return v;
    } else
    {
      println("pick a correct axis of rotation");
      return null;
    }
  }
}




PVector[][] getCentroidSmooth(PVector[][] raw)
{
  PVector[][] centroidList = new PVector[raw.length][raw[0].length];


  for (int i=0; i<raw.length; i++)
  { 
    for (int j=0; j<raw[0].length; j++)
    {
      if (i > 0 && i < raw.length-1 && j > 0 && j < raw[0].length-1)
      {
        PVector origin = raw[i][j].copy();

        PVector v0 = raw[i-1][j].copy();
        PVector v1 = raw[i+1][j].copy();
        PVector v2 = raw[i][j-1].copy();
        PVector v3 = raw[i][j+1].copy();

        PVector c0 = origin.copy().add(v0).add(v2);
        c0.div(3);
        PVector c1 = origin.copy().add(v1).add(v2);
        c1.div(3);
        PVector c2 = origin.copy().add(v1).add(v3);
        c2.div(3);
        PVector c3 = origin.copy().add(v0).add(v3);
        c3.div(3);


        //Compute le sum of neighbores vertex
        PVector sum = c0.copy().add(c1).add(c2).add(c3);

        //divide by numbers of neighbores
        sum.div(4);

        centroidList[i][j] = sum.copy();
      } else
      {
        if (i > 0 && i<raw.length-1 && j == 0) //top
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i-1][j].copy();
          PVector v1 = raw[i+1][j].copy();
          PVector v2 = raw[i][j+1].copy();

          PVector c0 = origin.copy().add(v0).add(v2);
          c0.div(3);
          PVector c1 = origin.copy().add(v1).add(v2);
          c1.div(3);


          //Compute le sum of neighbores vertex
          PVector sum = c0.copy().add(c1);

          //divide by numbers of neighbores
          sum.div(2);

          centroidList[i][j] = sum.copy();
        } else if (i > 0 && i<raw.length-1 && j < raw[0].length) //bottom
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i-1][j].copy();
          PVector v1 = raw[i+1][j].copy();
          PVector v2 = raw[i][j-1].copy();

          PVector c0 = origin.copy().add(v0).add(v2);
          c0.div(3);
          PVector c1 = origin.copy().add(v1).add(v2);
          c1.div(3);


          //Compute le sum of neighbores vertex
          PVector sum = c0.copy().add(c1);

          //divide by numbers of neighbores
          sum.div(2);

          centroidList[i][j] = sum.copy();
        } else if (j > 0 && j<raw[0].length-1 && i == 0) //left
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i][j+1].copy();
          PVector v1 = raw[i+1][j].copy();
          PVector v2 = raw[i][j-1].copy();

          PVector c0 = origin.copy().add(v0).add(v2);
          c0.div(3);
          PVector c1 = origin.copy().add(v1).add(v2);
          c1.div(3);


          //Compute le sum of neighbores vertex
          PVector sum = c0.copy().add(c1);

          //divide by numbers of neighbores
          sum.div(2);

          centroidList[i][j] = sum.copy();
        } else if (j > 0 && j<raw[0].length-1 && i < raw.length) //right
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i][j+1].copy();
          PVector v1 = raw[i-1][j].copy();
          PVector v2 = raw[i][j-1].copy();

          PVector c0 = origin.copy().add(v0).add(v2);
          c0.div(3);
          PVector c1 = origin.copy().add(v1).add(v2);
          c1.div(3);


          //Compute le sum of neighbores vertex
          PVector sum = c0.copy().add(c1);

          //divide by numbers of neighbores
          sum.div(2);

          centroidList[i][j] = sum.copy();
        }
        //corners
        else if (i == 0 && j==0) //TOP LEFT
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i+1][j].copy();
          PVector v1 = raw[i][j].copy();

          PVector c0 = origin.copy().add(v0).add(v1);
          c0.div(3);

          centroidList[i][j] = c0.copy();
        } else if (i == 0 && j== raw[0].length-1) //BOTTOM LEFT
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i+1][j].copy();
          PVector v1 = raw[i][j-1].copy();

          PVector c0 = origin.copy().add(v0).add(v1);
          c0.div(3);

          centroidList[i][j] = c0.copy();
        } else if (i == raw.length-1 && j== 0) //TOP RIGHT
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i-1][j].copy();
          PVector v1 = raw[i][j+1].copy();

          PVector c0 = origin.copy().add(v0).add(v1);
          c0.div(3);

          centroidList[i][j] = c0.copy();
        } else if (i == raw.length-1 && j == raw[0].length-1) //BOTTOM RIGHT
        {
          PVector origin = raw[i][j].copy();

          PVector v0 = raw[i-1][j].copy();
          PVector v1 = raw[i][j-1].copy();

          PVector c0 = origin.copy().add(v0).add(v1);
          c0.div(3);

          centroidList[i][j] = c0.copy();
        } else
        {
          centroidList[i][j] = raw[i][j].copy();
        }
      }
    }
  }

  return centroidList;
}