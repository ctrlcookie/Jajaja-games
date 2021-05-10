void frequencystuff() { //UNFINISHED change color ?
  background(0);
  colorMode(RGB);

  for (int i = 0; i < fft.specSize(); i++) //to be fixed, possibly
  { 
    //stroke(fft.getBand(i)*8); //interesting  choice on black background
    stroke(fft.getBand(i)*8, fft.getBand(i)*16, fft.getBand(i)*32); //color version
    strokeWeight(1);

    // draw the line for frequency band i, scaling it up a bit so we can see it
    //line( i, height, i, height - fft.getBand(i)*8 ); //basic
    //line( i, height, height - fft.getBand(i)*8, i ); //diagonal, it's cool
    //line( height, i, i, height - fft.getBand(i)*8 ); //same as 2 but other way
    line( width, i, i*2, height  - fft.getBand(i)*8 ); //same as 3 but with cool pattern and fixed
    line( i, width, i*2, height  - fft.getBand(i)*8 ); //enable with previous (4) for 3d look
    //line( i, width, height  - fft.getBand(i)*8, i*2 ); //same as 4 but other way
    println(fft.getBand(i));
  }
}

void wavylads() {   //UNFINISHED spruce it up a lil
  colorMode(HSB);
  strokeWeight(1);
  background(0);
  stroke(255);

  float sum = 0;

  for (int j = 0; j < buffer.size(); j ++) 
  {
    float c = map(j, 0, buffer.size(), 0, 255); //5 things given to map
    stroke(c, 255, 255);
    float sample = buffer.get(j) * (height / 2);  

    pushMatrix();
    translate(0, -90, -50);
    rotateX(570);
    line(j, height/4, j, (height / 2) - sample);  
    popMatrix();

    pushMatrix();
    translate(1014, 795, -50);
    rotateX(570);
    rotateY(radians(180));
    line(j, height/4, j, (height / 2) - sample); 
    popMatrix();

    pushMatrix();
    translate(0, -90, -50);
    rotateX(570);
    rotateY(-89.67);
    line(j, height/4, j, (height / 2) - sample);   
    popMatrix();

    pushMatrix();
    translate(1020, -90, -50);
    rotateX(570);
    rotateY(-89.42);
    line(j, height/4, j, (height / 2) - sample); 
    popMatrix();

    sum += abs(buffer.get(j));
  }
  float average = sum / buffer.size();
  smoothedAverage = lerp(smoothedAverage, average, 0.1);
}

void circleboxes() { //UNFINISHED
  strokeWeight(3);
  background(0);

  pushMatrix();
  stroke(palette5[2]);
  translate(width/2, height/2, 50);
  rotateX(theta);
  theta += TWO_PI/500;
  rect(0, 0, kickSize, kickSize-15);
  popMatrix();

  pushMatrix();
  stroke(palette5[1]);
  translate(width/2, height/2, 50);
  rotateY(theta);
  theta += TWO_PI/500;
  rect(0, 0, snareSize, snareSize);
  popMatrix();

  pushMatrix();
  stroke(palette5[0]);
  translate(width/2, height/2, 50);
  rotateZ(theta);
  theta += TWO_PI/500;
  rect(0, 0, hatSize+15, hatSize+15);
  popMatrix();

  strokeWeight(2);

  pushMatrix();
  stroke(palette5[3]);
  translate(width/2, height/2, 50);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  theta += TWO_PI/500;
  sphereDetail(8);
  sphere(40);
  popMatrix();

  pushMatrix();
  stroke(palette5[4]);
  translate(width/2, height/2, 50);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  theta += TWO_PI/500;
  sphereDetail(8);
  sphere(20);
  popMatrix();

  pushMatrix();
  stroke(palette5[2]);
  translate(width/2, height/2, 50);
  rotateX(theta/2);
  rotateY(theta/2);
  theta += TWO_PI/500;
  rect(0, 0, 130, 130);
  popMatrix();

  pushMatrix();
  stroke(palette5[1]);
  translate(width/2, height/2, 50);
  rotateY(theta/2);
  rotateZ(theta/2);
  theta += TWO_PI/500;
  rect(0, 0, 150, 150);
  popMatrix();
}

void threedeewave() { //FINISHED
  background(0);
  float sum = 0;
  pushMatrix();
  translate(100, 0, -150);
  for (int k = 0; k < buffer.size(); k ++) 
  {
    float c = map(k, 0, buffer.size(), 0, 255);
    stroke(c, 255, 255);

    float sample = buffer.get(k) * (height / 2);  
    rect(k, height / 2 - sample, (height / 2) - sample, k); 

    sum += abs(buffer.get(k));
  }
  popMatrix();
  float average = sum / buffer.size();
  smoothedAverage = lerp(smoothedAverage, average, 0.1);
}

void spiralstuffs() { //FINISHED
  float sum = 0;

  for (int l = 0; l < buffer.size(); l ++) 
  {
    float c = map(l, 0, buffer.size(), 0, 255); 
    stroke(c, 255, 255);
    float sample = buffer.get(l) * (height / 2);  

    sum += abs(buffer.get(l));
    ellipse(width/2, height/2, smoothedAverage * (l * 20), smoothedAverage * (l * 20));
  }
  float average = sum / buffer.size();
  smoothedAverage = lerp(smoothedAverage, average, 0.1);
  //ellipse(width/2, height/2, smoothedAverage * 350, smoothedAverage * 350);
  //ellipse(width/2, height/2, smoothedAverage * 250, smoothedAverage * 250);
  //ellipse(width/2, height/2, smoothedAverage * 200, smoothedAverage * 200);
  //ellipse(width/2, height/2, smoothedAverage * 150, smoothedAverage * 150);
}

void pixelbath() { //FINISHED
  float goup = 0.03;
  colorMode(HSB);

  loadPixels();

  float xoff = 0.0; // Start xoff at 0
  for (int i = 0; i < fft.specSize(); i++) //to be fixed, possibly
  {
  float detail = map(fft.getBand(i), 0, .09, 0.1, 0.6); 
  noiseDetail(8, detail);}

  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    xoff += goup; 
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < height; y++) {
      yoff += goup; 

      // Calculate noise and scale by 255
      float bright = noise(xoff, yoff) * 255;

      // Set each pixel onscreen to a color value
      pixels[x+y*width] = color(bright + 10, 255, 255);
    }
  }

  updatePixels();
}