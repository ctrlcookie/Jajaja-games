import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
FFT fft;
AudioPlayer player;
AudioBuffer buffer;

float currentVolume;
float lerpedVolume;

int cols, rows;
int scl = 20;
int w = 2000;
int h = 1600;

float speed = 0;
float rate = -0.05;
float lerpedRate;
float speedDivider = 1;
float lerpedSpeedDiv;

float[][] terrain;

float maxHeight;

float backgroundColor;
float backgroundLerp;

float backgroundColorH;

float heightMultiplier;
float lerpedMultiplier;

void setup() 
{
  size(1024, 600, P3D);

  cols = w / scl;
  rows = h/ scl;

  terrain = new float[cols][rows];



  minim = new Minim (this);


  player = minim.loadFile("Song.mp3", width);
  player.play();
  buffer = player.mix;
  fft = new FFT(width, 44100);
}


void draw() 
{
  float heightasColor = 0;

  colorMode (HSB);
  CalculateVolume();

  currentVolume = map(currentVolume, 0, 1500, 50, 200);
  lerpedVolume = lerp (lerpedVolume, currentVolume, 0.2f);

  lerpedRate = lerp (lerpedRate, rate, 0.5f);
  lerpedSpeedDiv = lerp (lerpedSpeedDiv, speedDivider, 0.1f);
  
  lerpedMultiplier = lerp (lerpedMultiplier, heightMultiplier, 0.2f);

  backgroundColor = lerp (backgroundColor, 0, 0.1);

  maxHeight = lerpedVolume / 50; 
  speed -= lerpedRate;

  if (currentVolume > 65)
  {
    rate = random (-0.15, 0.15);
    // speedDivider = random (0.9, 1.3);

    backgroundColor = 255;
    backgroundColorH = random (0, 255);
  }

  float yoff = speed / speedDivider;
  for (int y = 0; y < rows; y++) {
    float xoff  = speed * speedDivider;
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
