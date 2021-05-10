import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


  Minim minim;
  AudioInput ai;
  AudioBuffer ab;
  AudioPlayer ap;

void setup()
{
 size (512, 512, P3D);
 
 minim = new Minim(this);
 //ai = minim.getLineIn(Minim.MONO, 512, 44100, 16);
 //ab = ai.mix;
 ap = minim.loadFile("Apollo Rising & Float Point - Sanctuary.mp3", width);
 ab = ap.mix;
 
 
 ap.play();
 
 
 for(int i = 0 ; i < Cube ; i++) 
  {
   
    cx[i] = random(0, width);
    cy[i] = random(0, height);
    cspeed[i] = random(-2, -15); // this changes how quick they go across the screen
    cSize[i] = random(25, 50); // this will change the size of the spheres
    cColorR[i] = random(1, 255);
    cColorG[i] = random(0, 0);
    cColorB[i] = random(1, 153);
  }
 
}

int Cube = 15;// this is the number of spheres
float[] cx = new float[Cube];
float[] cy = new float[Cube];
float[] cspeed = new float[Cube];
float[] cSize = new float[Cube];
float[] cColorR = new float[Cube];
float[] cColorG = new float[Cube];
float[] cColorB = new float[Cube];

float theta = 0;

float lerpedAverage = 0;

float[] lerpedBuffer;
float[] lerpedFFT;

int frameSize = 512;

float x = 0;

FFT fft;


void draw()
{
  float sum = 0;
  for (int i = 0 ; i < ab.size() ; i ++)
  {
    sum += abs(ab.get(i));
  }
  float average = sum / (float) ab.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);
  background(0);
  lights();
  noFill();
  
  for(int i = 0 ; i < Cube ; i ++) // sphere creation
  {
    pushMatrix();
    translate(cx[i], cy[i], cSize[i]);
    box(cSize[i] +(lerpedAverage * 500));
    popMatrix();
    stroke (cColorR[i], cColorG[i], cColorB[i]);
    theta += cspeed[i];
    cy[i] += cspeed[i];
    
    if (cy[i] < 0) // this basically says "after it reaches this height (Y 0), make a new sphere here (Y Height)"
    {
      cx[i] = random(0, width);
      cy[i] = height;
      cspeed[i] = random(-2, -15);
      cSize[i] = random(25, 50);
      cColorR[i] = random(1, 255);
      cColorG[i] = random(0, 0);
      cColorB[i] = random(1, 255);
    }
    
  }
}
