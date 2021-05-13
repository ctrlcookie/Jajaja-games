//James Mohan [studentnumberhere]

void bubblelads() { //fix colours
  colorMode(RGB);
  noFill();
  noStroke();

  float sum = 0;

  for (int z = 0; z < buffer.size(); z ++)
  {
    sum += abs(buffer.get(z));
  }

  float average = sum / (float) buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);


  for (int y = 0; y < Sphere; y ++) // sphere creation
  {
    pushMatrix();
    translate(sx[y], sy[y], sSize[y]);
    rotateX(theta);
    rotateY(theta);
    rotateZ(theta);
    sphere(sSize[y] +(lerpedAverage * 500));
    popMatrix();
    stroke (sColorR[y], sColorG[y], sColorB[y]);
    theta += sspeed[y];
    sy[y] += sspeed[y];

    if (sy[y] < 0) // this basically says "after it reaches this height (Y 0), make a new sphere here (Y Height)"
    {
      sx[y] = random(0, width);
      sy[y] = height;
      sspeed[y] = random(-2, -15);
      sSize[y] = random(25, 50);
      sColorR[y] = random(1, 102);
      sColorG[y] = random(1, 255);
      sColorB[y] = random(153, 255);
    }
  }
}

//--------------------------------------------------------------------------------

void dissolving_wave() {
  colorMode(HSB);
  lerpedBuffer = new float[buffer.size()];
  background(0);

  strokeWeight(1);
  for (int i = 0; i < buffer.size(); i ++)
  {      
    stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
    lerpedBuffer[i] = lerp(lerpedBuffer[i], buffer.get(i), 0.1f);
    float sample = lerpedBuffer[i] * width * 2;    
    stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
    line(i, height / 2 - sample, i, height / 2);
  }


  float sum = 0;
  for (int i = 0; i <buffer.size(); i ++)
  {
    sum += abs(buffer.get(i));
  }

  noStroke();
  float average = sum / buffer.size();
  lerpedAvg = lerp(lerpedAvg, average, 0.1f);

  fft.window(FFT.HAMMING);
  fft.forward(buffer);
}

//---------------------------------------------------------------------------------

void cubeballoons() { //spheres code but cubes instead
  colorMode(RGB);
  noFill();
  noFill();

  float sum = 0;
  for (int i = 0; i <buffer.size(); i ++)
  {
    sum += abs(buffer.get(i));
  }
  float average = sum / (float) buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);
  background(0);
  lights();
  noFill();

  for (int i = 0; i < Cube; i ++) // sphere creation
  {
    pushMatrix();
    translate(cx[i], cy[i], cz[i]);
    box(cSize[i] +(lerpedAverage * 500));
    popMatrix();
    stroke (cColorR[i], cColorG[i], cColorB[i]);
    cz[i] += cspeed[i];

    if (cz[i] > 512) // this basically says "after it reaches this height (Y 0), make a new sphere here (Y Height)"
    {
      cx[i] = random(0, width);
      cy[i] = random(0, height);
      cz[i] = -512;
      cspeed[i] = random(2, 15);
      cSize[i] = random(25, 50);
      cColorR[i] = random(1, 255);
      cColorG[i] = random(0, 0);
      cColorB[i] = random(1, 255);
    }
  }
}

//--------------------------------------------------------------------------------

void cubematrix() {
  float sum = 0;
  for (int i = 0; i < buffer.size(); i ++)
  {
    sum += abs(buffer.get(i));
  }
  float average = sum / (float) buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);
  background(0);
  strokeWeight(2);
  noFill();
  lights();

  pushMatrix();
  stroke(2, 251, B);
  c.display();
  box (10 + (lerpedAverage * 500));
  popMatrix();

  pushMatrix();
  stroke(16, 216, B);
  c.display();
  box(20 + (lerpedAverage * 500));
  popMatrix();

  pushMatrix();
  stroke(28, 186, B);
  c.display();
  box(30 + (lerpedAverage * 500));
  popMatrix();

  pushMatrix();
  stroke(41, 152, B);
  c.display();
  box(40 + (lerpedAverage * 500));
  popMatrix();

  pushMatrix();
  stroke(54, 119, B);
  c.display();
  box(50 + (lerpedAverage * 500));
  popMatrix();

  pushMatrix();
  stroke(68, 86, B);
  c.display();
  box(60 + (lerpedAverage * 500));
  popMatrix();

  pushMatrix();
  stroke(80, 55, B);
  c.display();
  box(70 + (lerpedAverage * 500));
  popMatrix();

  pushMatrix();
  stroke(90, 20, B);
  c.display();
  box(80 + (lerpedAverage * 500));
  popMatrix();

  theta += speed;
}

class Cube {


  void display()
  {

    translate(width /2, height / 2, 0);
    rotateX(theta);
    rotateY(theta);
    rotateZ(theta);
  }
}
