//David Kuye [studentnumberhere], the song you're hearing is from him

void textscreen() {
  colorMode(HSB);
  textSize(128);

  CalculateVolume();
  currentVolume = map(currentVolume, 0, 1500, 50, 200);
  lerpedVolume = lerp (lerpedVolume, currentVolume, 0.2f);

  textHue = map(currentVolume, 0, 1500, 0, 5000);
  lerpedHue = lerp (lerpedHue, textHue, 0.5f);

  amount = map(currentVolume, 0, 100, 1, 10);
  lerpedAmount = lerp (lerpedAmount, amount, 0.5f);
  //lerpedAmount = round(lerpedAmount);

  background(0);

  //DRAW TEXT AND ROTATE
  translate(width * .5, height*.5, 0);
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateX(map(-mouseY, 0, height, -PI, PI));
  //rotate on the z axis is a bit more complicated
  lerpedRotAmount = lerp (lerpedRotAmount, rotAmount, 0.2f); 
  if (currentVolume > 60)
  {
    rotAmount = random(-10, 10);
  }  
  rotateZ(radians(lerpedRotAmount));
  //draw text
  pushMatrix();
  textSize(lerpedVolume);
  textAlign(CENTER);
  for (int i = 0; i < lerpedAmount; i++)
  {
    fill (lerpedHue - i * 10, 255, 255);
    text("JaJaJa Games Presents", -20, 0, 20 * i);
  } 
  popMatrix();
}

//-------------------------------------------------------------------------------

void CalculateVolume() 
{
  fft.window (FFT.HAMMING); 
  fft.forward (buffer); 

  currentVolume = 0; 

  for (int i = 0; i < fft.specSize(); i++)
  {
    //filter out any low frequencies 
    if (fft.indexToFreq(i) > 1000) {
      currentVolume += fft.getBand (i);
    }
  }
}

//-------------------------------------------------------------------------------

void rotatingplanet()    
{
  strokeWeight(1);
  colorMode (HSB);
  CalculateVolume();

  currentVolume = map(currentVolume, 0, 1500, 50, 200);
  lerpedVolume = lerp (lerpedVolume, currentVolume, 0.2f);

  lerpedRate = lerp (lerpedRate, rate, 0.5f);
  lerpedSpeedDiv = lerp (lerpedSpeedDiv, SpeedDivider, 0.1f);

  lerpedMultiplier = lerp (lerpedMultiplier, heightMultiplier, 0.2f);

  backgroundColor = lerp (backgroundColor, 0, 0.1);

  maxHeight = lerpedVolume / 50; 
  Speed -= lerpedRate;

  if (currentVolume > 65)
  {
    rate = random (-0.15, 0.15);
    // SpeedDivider = random (0.9, 1.3);

    backgroundColor = 255;
    backgroundColorH = random (0, 255);
  }

  float yoff = Speed / SpeedDivider;
  for (int y = 0; y < rows; y++) {
    float xoff  = Speed * SpeedDivider;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
      //heightasColor = map(terrain[x][y], -100, 100, 0, 255);
      xoff += 0.2;
    }
    yoff += 0.2;
  }

  heightMultiplier = map (lerpedVolume, 50, 80, 1, 10);

  background(backgroundColorH, 255, backgroundColor);
  stroke(lerpedVolume);

  translate(width / 2, height / 2 + 50);
  rotateX(PI / 3);
  translate(-w / 2, -h / 2);
  //fill (random (0, 255), 255, 255);
  for (int y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {

      fill (lerpedVolume * 2, 255, 255);
      vertex(x*scl, y*scl, terrain[x][y] * lerpedMultiplier);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1] * lerpedMultiplier);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }

  pushMatrix();
  noStroke();
  fill(160, 255, 255); 
  translate (1000, 1000, -20);
  box (2000, 2000, 10);
  popMatrix();
}
