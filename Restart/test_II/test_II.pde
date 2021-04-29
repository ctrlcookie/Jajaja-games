/** The plan as it stands: make a number of visuals that can be swapped-between
*in such a way that it looks nice and feels natural for the length of a song.
*I am working in this file. If you wish to add on to the things i am doing
*then please copy the file and work there (or just give me the advice).
* It would be best if you didn't do that though, and instead worked in new file
* on a different visual that can then be spliced into one project.
* But for the love of all this is holy, use the same size() to make migration at the end easier.
*/



import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

color[] palette1 = {#33582E, #E8DF97, #D6A85C, #8C5330, #65190F}; //warms n a green
color[] palette2 = {#EDF3C5, #7CAE8D, #C7BC3E, #F38341, #E14339}; //warm cool mix
color[] palette3 = {#A10B39, #BA2232, #4A6255, #4BAC61, #14D0D3}; //red n blue greens
//color[] palette4 = {#ffffff,#ff0000,#65190F,#65190F,#65190F};
//color[] palette5 = {#ffffff,#ff0000,#65190F,#65190F,#65190F};


float theta = 0;
float speed = 0.01f;
float lerpedAverage = 0;
float lerpedFrequency = 0;
float audioFrequency = 0;
float kickSize, snareSize, hatSize; 

FFT fft; //using fast fourier transform
Minim minim; //using minim library
AudioPlayer audioSample; //the song we're using
AudioBuffer buffer; //buffer (list of samples) from the song we're using
BeatDetect beats; //standard beat that we're detecting
BeatDetect beat; //above but more specific see below
BeatListener beatlistener; //a beat listener, what more can i say

class BeatListener implements AudioListener //taken from minim library, part of "beat stuff"
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup() {
  size(800, 600, P3D);
  smooth();
  rectMode(CENTER);
  noFill();

  minim = new Minim (this); //minim lib
  audioSample = minim.loadFile("SZA.mp3", 1024); //sample
  audioSample.play(); //play sample
  //audioSample.loop(); //loop sample
  buffer = audioSample.mix; //buffer left and right input mixed
  fft = new FFT(audioSample.bufferSize(), audioSample.sampleRate()); // what we're FFTing
  beats = new BeatDetect(); //standard beat detection, 10ms 
  beat = new BeatDetect(audioSample.bufferSize(), audioSample.sampleRate()); // expects buffers the length of song's buffer size and samples captured at songs's sample rate
  beat.setSensitivity(300);  //wait for 300 milliseconds before allowing another beat to be detected
  kickSize = snareSize = hatSize = 100; //variables we'll be using in a bit
  beatlistener = new BeatListener(beat, audioSample);    // new beat listener, so that we won't miss any buffers for the analysis, according to the documentation
}

void draw() {
  background(0);
  lights();

  fft.window (FFT.HAMMING); //it's important
  fft.forward(audioSample.mix); 

  //beat stuff
  beats.detect(audioSample.mix); //detect beat from audioSample
  //if ( beat.isOnset() ){ //how to check if a beat is detected
  //  background(100);
  //}
  if ( beat.isKick() ) kickSize = 150;
  if ( beat.isSnare() ) snareSize = 150;
  if ( beat.isHat() ) hatSize = 150;

  //frequency stuff
  for (int i = 0; i < fft.specSize(); i++) //to be fixed, possibly
  { 
    //stroke(fft.getBand(i)*8); //interesting  choice on black background
    stroke(fft.getBand(i)*32, fft.getBand(i)*16, fft.getBand(i)*8); //color version
    strokeWeight(1);

    // draw the line for frequency band i, scaling it up a bit so we can see it
    //line( i, height, i, height - fft.getBand(i)*8 ); //basic
    //line( i, height, height - fft.getBand(i)*8, i ); //diagonal, it's cool
    //line( height, i, i, height - fft.getBand(i)*8 ); //same as 2 but other way
    line( width, i, i*2, height  - fft.getBand(i)*8 ); //same as 3 but with cool pattern and fixed
    line( i, width, i*2, height  - fft.getBand(i)*8 ); //enable with previous (4) for 3d look
    //line( i, width, height  - fft.getBand(i)*8, i*2 ); //same as 4 but other way
  }

  strokeWeight(2);

  pushMatrix();
  stroke(50);
  translate(width/2, height/2, 50);
  rotateX(theta);
  theta += TWO_PI/500;
  rect(0, 0, kickSize, kickSize);
  popMatrix();

  pushMatrix();
  stroke(100);
  translate(width/2, height/2, 50);
  rotateY(theta);
  theta += TWO_PI/500;
  rect(0, 0, snareSize, snareSize);
  popMatrix();

  pushMatrix();
  stroke(200);
  translate(width/2, height/2, 50);
  rotateZ(theta);
  theta += TWO_PI/500;
  rect(0, 0, hatSize, hatSize);
  popMatrix();

  pushMatrix();
  translate(width/2, height/2, 50);
  rotateX(theta);
  rotateY(theta);
  rotateZ(theta);
  theta += TWO_PI/500;
  sphereDetail(15);
  sphere(40);
  popMatrix();

  kickSize = constrain(kickSize * 0.95, 100, 150);
  snareSize = constrain(snareSize * 0.95, 100, 150);
  hatSize = constrain(hatSize * 0.95, 100, 150);
}
