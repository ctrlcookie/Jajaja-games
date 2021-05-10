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
 size (500, 500, P3D);
 
  minim = new Minim(this);
 //ai = minim.getLineIn(Minim.MONO, 512, 44100, 16);
 //ab = ai.mix;
 ap = minim.loadFile("Apollo Rising & Float Point - Sanctuary.mp3", width);
 ab = ap.mix;
 
 ap.play();
}

float theta = 0;
float speed = 0.01f;
float moveSpeed = 1;

float lerpedAverage;

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
  stroke(2, 251, 255);
  translate(width /2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(10 + (lerpedAverage * 500));
  popMatrix();
  
  pushMatrix();
  stroke(16, 216, 255);
  translate(width / 2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(20 + (lerpedAverage * 500));
  popMatrix();
  
  pushMatrix();
  stroke(28, 186, 255);
  translate(width / 2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(30 + (lerpedAverage * 500));
  popMatrix();
  
  pushMatrix();
  stroke(41, 152, 255);
  translate(width /2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(40 + (lerpedAverage * 500));
  popMatrix();
  
  pushMatrix();
  stroke(54, 119, 255);
  translate(width /2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(50 + (lerpedAverage * 500));
  popMatrix();
  
  pushMatrix();
  stroke(68, 86, 255);
  translate(width /2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(60 + (lerpedAverage * 500));
  popMatrix();
  
  pushMatrix();
  stroke(80, 55, 255);
  translate(width /2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(70 + (lerpedAverage * 500));
  popMatrix();
  
  pushMatrix();
  stroke(90, 20, 255);
  translate(width /2, height / 2, 0);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  box(80 + (lerpedAverage * 500));
  popMatrix();
  
  theta += speed;
}
