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
 
 
 for(int i = 0 ; i < Sphere ; i++) 
  {
   
    sx[i] = random(0, width);
    sy[i] = random(0, height);
    sspeed[i] = random(-2, -15); // this changes how quick they go across the screen
    sSize[i] = random(25, 50); // this will change the size of the spheres
    sColorR[i] = random(1, 102);
    sColorG[i] = random(1, 255);
    sColorB[i] = random(153, 255);
  }
 
}

int Sphere = 15;// this is the number of spheres
float[] sx = new float[Sphere];
float[] sy = new float[Sphere];
float[] sspeed = new float[Sphere];
float[] sSize = new float[Sphere];
float[] sColorR = new float[Sphere];
float[] sColorG = new float[Sphere];
float[] sColorB = new float[Sphere];

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
  
  for(int i = 0 ; i < Sphere ; i ++) // sphere creation
  {
    pushMatrix();
    translate(sx[i], sy[i], sSize[i]);
    rotateX(theta);
    rotateY(theta);
    rotateZ(theta);
    sphere(sSize[i] +(lerpedAverage * 500));
    popMatrix();
    stroke (sColorR[i], sColorG[i], sColorB[i]);
    theta += sspeed[i];
    sy[i] += sspeed[i];
    
    if (sy[i] < 0) // this basically says "after it reaches this height (Y 0), make a new sphere here (Y Height)"
    {
      sx[i] = random(0, width);
      sy[i] = height;
      sspeed[i] = random(-2, -15);
      sSize[i] = random(25, 50);
      sColorR[i] = random(1, 102);
      sColorG[i] = random(1, 255);
      sColorB[i] = random(153, 255);
    }
    
  }
}
