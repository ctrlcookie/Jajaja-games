import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer ap;
AudioBuffer ab;
AudioInput ai;

float lerpedAverage = 0;

float[] lerpedBuffer;
float[] lerpedFFT;

int frameSize = 512;

float x = 0;


FFT fft;

void setup()
{
  size(512, 512,P3D);
  colorMode(HSB);
  minim = new Minim(this);
  
  ap = minim.loadFile("Apollo Rising & Float Point - Sanctuary.mp3", width);
  
  ab = ap.left;

  lerpedBuffer = new float[ab.size()];
  
  fft = new FFT(frameSize, 44100);
}

int which = 1;

void draw()
{
  background(0);
  float halfHeight = height / 2;
  
  
  strokeWeight(1);
  for (int i = 0; i < ab.size(); i ++)
  {
    
    if(which == 1)
    {
    stroke(map(i, 0, ab.size(), 0, 255), 255, 255);
    lerpedBuffer[i] = lerp(lerpedBuffer[i], ab.get(i), 0.1f);
    float sample = lerpedBuffer[i] * width * 2;    
    stroke(map(i, 0, ab.size(), 0, 255), 255, 255);
    line(i, height / 2 - sample, i, height / 2); 
    }
  }
 
  
  float sum = 0;
  for (int i = 0; i <ab.size(); i ++)
  {
    sum += abs(ab.get(i));
  }

  noStroke();
  float average = sum / ab.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);
  
  if(which == 2)
  {
  rectMode(CENTER);
  noFill();  
  stroke(map(lerpedAverage, 0, 1, 0, 255), 255, 255);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 0,  lerpedAverage * halfHeight * 0);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 4,  lerpedAverage * halfHeight * 4);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 8,  lerpedAverage * halfHeight * 8);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 12,  lerpedAverage * halfHeight * 12);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 16,  lerpedAverage * halfHeight * 16);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 20,  lerpedAverage * halfHeight * 20);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 24,  lerpedAverage * halfHeight * 24);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 28,  lerpedAverage * halfHeight * 28);
  rect(width / 2, halfHeight,  lerpedAverage * halfHeight * 32,  lerpedAverage * halfHeight * 32);
  }
  
  
  fft.window(FFT.HAMMING);
  fft.forward(ab); 
}

void keyPressed()
{
  // Set the value of which based on which key was pressed
  if (keyCode >= '0' && keyCode <= '3')
  {
    which = keyCode - '1';
  }
  if (keyCode == ' ')
  {
    if ( ap.isPlaying() )
    {
      ap.pause();
    }
    else
    {
      ap.rewind();
      ap.play();
    }
  }
}
