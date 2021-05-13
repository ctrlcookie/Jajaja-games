import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//FFT fft;
float theta = 0;
float speed = 0.01f;
float lerpedAverage = 0;
Minim minim;
AudioPlayer audioSample;
AudioBuffer buffer;

void setup() {
  size(1000, 500, P2D);
  background(255);
  rectMode(CENTER);
  shapeMode(CENTER);

  minim = new Minim (this);
  //fft = new FFT(width, 44100);  
  audioSample = minim.loadFile("SZA.mp3", width);
  audioSample.play();
  buffer = audioSample.mix;
    colorMode(HSB);
}


void draw() {
  //fft.window(FFT.HAMMING); 
  //fft.forward(buffer);
  int rectSize= 50;
  
  //draw sea background
  for (int i = 0; i < buffer.size(); i ++) //for every i smaller than the size of the audio buffer
  {
    float c = map(i, 0, buffer.size(), 0, 255);  //map (aka change the rangeof a value from one range to another) the buffer size to values between 0 and 255 
    noStroke();  
    fill(255, c, 255);//makes color change each iteration
  fill(150, c, 255);
  rect(random(-width,width) + i - random(1, 200), 700 - i - random(1, 20), rectSize, rectSize);
  
  float sum = 0;
  for(int j = 0; j< buffer.size() ; j++){
  sum += abs(buffer.get(j));
  }
  float average = sum/(float) buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.01f);
 }


}
