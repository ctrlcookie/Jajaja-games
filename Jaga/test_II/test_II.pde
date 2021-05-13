//Jadwiga Walkowiak [studentnumberhere]

import ddf.minim.*;  //minimlibrary
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
boolean switchcolormode;
float x;
float y;
float lerpedAverage = 0;
float lerpedFrequency = 0;
float audioFrequency = 0;
float kickSize, snareSize, hatSize; 
float smoothedAverage = 0;
int switchnum = 0;
int maxswitch = 12; //max number of switch statements before looping back to the first
boolean playing = false; //is the audio playing?

//JMs variables
float speed = 0.01f;
int Sphere = 20;
int Cube = 20;
float[] sx = new float[Sphere];
float[] sy = new float[Sphere];
float[] sspeed = new float[Sphere];
float[] sSize = new float[Sphere];
float[] sColorR = new float[Sphere];
float[] sColorG = new float[Sphere];
float[] sColorB = new float[Sphere];

float[] cx = new float[Cube];
float[] cy = new float[Cube];
float[] cz = new float[Cube];
float[] cspeed = new float[Cube];
float[] cSize = new float[Cube];
float[] cColorR = new float[Cube];
float[] cColorG = new float[Cube];
float[] cColorB = new float[Cube];

float[] lerpedFFT;

float B = 255;

//JRs variables
float[] lerpedBuffer;
float lerpedAvg = 0;
float currentVolume;
float lerpedVolume;
float textHue;
float lerpedHue;
float amount;
float lerpedAmount;
float rotAmount;
float lerpedRotAmount;

int cols, rows;
int scl = 20;
int w = 2000;
int h = 1600;

float Speed = 0;
float rate = -0.05;
float lerpedRate;
float SpeedDivider = 1;
float lerpedSpeedDiv;

float[][] terrain;

float maxHeight;

float backgroundColor;
float backgroundLerp;

float backgroundColorH;

float heightMultiplier;
float lerpedMultiplier;

Cube c;
FFT fft; //using fast fourier transform
Minim minim; //using minim library
AudioPlayer audioSample; //the song we're using
AudioBuffer buffer; //buffer (list of samples) from the song we're using
BeatDetect beats; //standard beat that we're detecting
BeatDetect beat; //above but more specific see below
BeatListener beatlistener; //a beat listener, what more can i say
AudioBuffer ab; //mic buffer

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
  noCursor();

  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];


  c = new Cube();


  minim = new Minim (this); //minim lib
  audioSample = minim.loadFile("Song.mp3", 1024); //sample
  //audioSample.loop(); //loop sample
  buffer = audioSample.mix; //buffer left and right input mixed
  fft = new FFT(audioSample.bufferSize(), audioSample.sampleRate()); // what we're FFTing
  beats = new BeatDetect(); //standard beat detection, 10ms 
  beat = new BeatDetect(audioSample.bufferSize(), audioSample.sampleRate()); // expects buffers the length of song's buffer size and samples captured at songs's sample rate
  beat.setSensitivity(300);  //wait for 300 milliseconds before allowing another beat to be detected
  kickSize = snareSize = hatSize = 100; //variables we'll be using in a bit
  beatlistener = new BeatListener(beat, audioSample);    // new beat listener, so that we won't miss any buffers for the analysis, according to the documentation
  colorMode(HSB);

  //JM bubblelads and cubeballoons
  for (int i = 0; i < Sphere; i++) 
  {

    sx[i] = random(0, width);
    sy[i] = random(0, height);
    sspeed[i] = random(-2, -15); // this changes how quick they go across the screen
    sSize[i] = random(25, 50); // this will change the size of the spheres
    sColorR[i] = random(1, 102);
    sColorG[i] = random(1, 255);
    sColorB[i] = random(153, 255);
    cx[i] = random(0, width);
    cy[i] = random(0, height);
    cz[i] = random(-512, 100);
    cspeed[i] = random(2, 15); // this changes how quick they go across the screen
    cSize[i] = random(25, 50); // this will change the size of the spheres
    cColorR[i] = random(1, 255);
    cColorG[i] = random(0, 0);
    cColorB[i] = random(1, 153);
  }
}

void keyReleased() {
  if (keyCode == ' ') { //pausing was James' idea
    if ( !playing) {
      playing = true;
      audioSample.play(); //play sample
    } else {
      playing = false;
      audioSample.pause(); //stop sample
    }
  } else if (key == 'a') { 
    if(!switchcolormode){
    switchcolormode = true;
    }else{
      switchcolormode = false;
    }
  
  } else { 
    switchnum += 1;  //switch visuals
    if (switchnum == maxswitch) { //loop back to case 0
      switchnum = 0;
    }
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
  if ( beat.isKick() ) kickSize = 150; //lerp it later??
  if ( beat.isSnare() ) snareSize = 150;
  if ( beat.isHat() ) hatSize = 150;


  switch(switchnum) {  //fixed
  case 0: 
    textscreen();     
    textSize(32);
    text("Controls: A, Space, and Mouse!", 0, height-500);
    println("zero");
    break;

  case 1: 
    sunrays();
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

  case 7: 
    dissolving_wave();     
    println("seven");
    break;

  case 8: 
    cubeballoons();     
    println("eight");
    break;

  case 9: 
    cubematrix();     
    println("nine");
    break;

  case 10: 
    circleboxes();
    println("ten");
    break;

  case 11: 
    rotatingplanet();     
    println("eleven");
    break;
  }

  kickSize = constrain(kickSize * 0.95, 100, 150);
  snareSize = constrain(snareSize * 0.95, 100, 150);
  hatSize = constrain(hatSize * 0.95, 100, 150);
}
