void bubblelads(){ //fix colours
  
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
    println(sColorR);
    println(sColorG);
    println(sColorB);
  }
}
