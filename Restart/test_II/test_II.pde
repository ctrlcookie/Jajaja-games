import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

color[] palette1 = {#33582E,#E8DF97, #D6A85C, #8C5330, #65190F}; //warms n a green
color[] palette2 = {#ffffff,#ff0000,#65190F,#65190F,#65190F};
color[] palette3 = {#ffffff,#ff0000,#65190F,#65190F,#65190F};
color[] palette4 = {#ffffff,#ff0000,#65190F,#65190F,#65190F};
color[] palette5 = {#ffffff,#ff0000,#65190F,#65190F,#65190F};


float theta = 0;
float speed = 0.01f;
float lerpedAverage = 0;
float lerpedFrequency = 0;
float audioFrequency = 0;

FFT fft;
Minim minim;
AudioPlayer audioSample;
AudioBuffer buffer;

void setup() {
  size(800, 600, P3D);
  smooth();
  rectMode(CENTER);
  noFill();

  minim = new Minim (this);
  audioSample = minim.loadFile("SZA.mp3", 1024);
  audioSample.play();
  buffer = audioSample.mix;
  fft = new FFT(audioSample.bufferSize(), audioSample.sampleRate());
}

void draw() {
  background(0);
  lights();

  fft.window (FFT.HAMMING);
  fft.forward(audioSample.mix);

  for (int i = 0; i < fft.specSize(); i++)
  { 
    stroke(255);
    // draw the line for frequency band i, scaling it up a bit so we can see it
    line( i, height, i, height - fft.getBand(i)*8 );
  }


  pushMatrix();
  stroke(50);
  translate(width/2, height/2);
  rotateX(theta);
  theta += TWO_PI/500;
  rect(0, 0, 100, 100);
  popMatrix();

  pushMatrix();
  stroke(100);
  translate(width/2, height/2);
  rotateY(theta);
  theta += TWO_PI/500;
  rect(0, 0, 100, 100);
  popMatrix();

  pushMatrix();
  stroke(200);
  translate(width/2, height/2);
  rotateZ(theta);
  theta += TWO_PI/500;
  rect(0, 0, 100, 100);
  popMatrix();

  pushMatrix();
  translate(width/2, height/2);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  theta += TWO_PI/500;
  sphereDetail(15);
  sphere(40);
  popMatrix();
}
