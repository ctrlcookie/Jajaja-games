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

Cube c;

void setup()
{
 size (512, 512, P3D);
 
 c = new Cube();
 
  minim = new Minim(this);
 //ai = minim.getLineIn(Minim.MONO, 512, 44100, 16);
 //ab = ai.mix;
 ap = minim.loadFile("Apollo Rising & Float Point - Sanctuary.mp3", width);
 ab = ap.mix;
 
 ap.play();
}

float x = 0;

float theta = 0;
float speed = 0.01f;
float moveSpeed = 1;

float lerpedAverage;

float B = 255;

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
  strokeWeight(2);
  noFill();
  //noStroke();
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
