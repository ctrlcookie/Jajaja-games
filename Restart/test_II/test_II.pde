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
color[] palette4 = {#392A30, #755C6A, #CAB992, #F3CC97, #C29A8E}; //purplish
color[] palette5 = {#D0E3BC, #8EBF87, #4A895B, #286147, #264D3A}; //bright


float theta = 0;
float lerpedAverage = 0;
float lerpedFrequency = 0;
float audioFrequency = 0;
float kickSize, snareSize, hatSize; 
float smoothedAverage = 0;
int switchnum = 0;
int maxswitch = 7;

int Sphere = 20;// this is the number of spheres
float[] sx = new float[Sphere];
float[] sy = new float[Sphere];
float[] sspeed = new float[Sphere];
float[] sSize = new float[Sphere];
float[] sColorR = new float[Sphere];
float[] sColorG = new float[Sphere];
float[] sColorB = new float[Sphere];



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
  size(1024, 600, P3D);
  smooth();
  rectMode(CENTER);
  noFill();

  minim = new Minim (this); //minim lib
  audioSample = minim.loadFile("Above Control.mp3", 1024); //sample
  audioSample.play(); //play sample
  //audioSample.loop(); //loop sample
  buffer = audioSample.mix; //buffer left and right input mixed
  fft = new FFT(audioSample.bufferSize(), audioSample.sampleRate()); // what we're FFTing
  beats = new BeatDetect(); //standard beat detection, 10ms 
  beat = new BeatDetect(audioSample.bufferSize(), audioSample.sampleRate()); // expects buffers the length of song's buffer size and samples captured at songs's sample rate
  beat.setSensitivity(300);  //wait for 300 milliseconds before allowing another beat to be detected
  kickSize = snareSize = hatSize = 100; //variables we'll be using in a bit
  beatlistener = new BeatListener(beat, audioSample);    // new beat listener, so that we won't miss any buffers for the analysis, according to the documentation
  colorMode(HSB);

  //JM bubblelads
  for (int i = 0; i < Sphere; i++) 
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

void keyReleased() {
  switchnum += 1;
  if (switchnum == maxswitch) {
    switchnum = 0;
  }
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
  if ( beat.isKick() ) kickSize = 150; //lerp it later
  if ( beat.isSnare() ) snareSize = 150;
  if ( beat.isHat() ) hatSize = 150;



  switch(switchnum) {  //this doesn't appear to work that well so find another way to do it
  case 0: 
    frequencystuff();
    println("zero");
    break;

  case 1: 
    circleboxes();
    println("one");
    break;

  case 2: 
    wavylads();
    println("two");
    break;

  case 3: 
    threedeewave();
    println("three");
    break;

  case 4: 
    spiralstuffs();
    println("four");
    break;

  case 5: 
    pixelbath();
    println("five");
    break;

  case 6: 
    bubblelads();
    println("six");
    break;
  }

  kickSize = constrain(kickSize * 0.95, 100, 150);
  snareSize = constrain(snareSize * 0.95, 100, 150);
  hatSize = constrain(hatSize * 0.95, 100, 150);
}
