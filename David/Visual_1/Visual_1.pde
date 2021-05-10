import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
FFT fft;
AudioPlayer player;
AudioBuffer buffer;

float currentVolume;
float lerpedVolume;
float textHue;
float lerpedHue;

float amount;
float lerpedAmount;

float rotAmount;
float lerpedRotAmount;

void setup() 
{ 
  size(1024, 500, P3D);

  minim = new Minim (this);


  player = minim.loadFile("Song.mp3", width);
  player.play();
  buffer = player.mix;

  fft = new FFT(width, 44100);

  colorMode(HSB);

  //ensures C R I S P Y text
  textSize(128);
} 

void draw() 
{ 
  CalculateVolume();
  currentVolume = map(currentVolume, 0, 1500, 50, 200);
  lerpedVolume = lerp (lerpedVolume, currentVolume, 0.2f);

  textHue = map(currentVolume, 0, 1500, 0, 5000);
  lerpedHue = lerp (lerpedHue, textHue, 0.5f);

  amount = map(currentVolume, 0, 100, 1, 10);
  lerpedAmount = lerp (lerpedAmount, amount, 0.5f);
  //lerpedAmount = round(lerpedAmount);

  background(0);

  //DRAW TEXT AND ROTATE
  translate(width * .5, height*.5, 0);
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateX(map(-mouseY, 0, height, -PI, PI));
  //rotate on the z axis is a bit more complicated
  lerpedRotAmount = lerp (lerpedRotAmount, rotAmount, 0.2f); 
  if(currentVolume > 60)
  {
    rotAmount = random(-5,5);
  }  
  rotateZ(radians(lerpedRotAmount));
  //draw text
  pushMatrix();
  textSize(lerpedVolume);
  textAlign(CENTER);
  for (int i = 0; i < lerpedAmount; i++)
  {
    fill (lerpedHue - i * 10, 255, 255);
    text("JaJaJa Games Presents", -20, 0, 20 * i);
  } 
    popMatrix();
}

void CalculateVolume() 
{
  fft.window (FFT.HAMMING); 
    fft.forward (buffer); 

    currentVolume = 0; 

    for (int i = 0; i < fft.specSize(); i++)
  {
    //filter out any low frequencies 
    if (fft.indexToFreq(i) > 1000) {
      currentVolume += fft.getBand (i);
    }
  }
}
