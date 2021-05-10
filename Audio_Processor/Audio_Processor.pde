import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//^imports

//FFT is used to analyse audio
FFT fft;
Minim minim;

//put audio here.
AudioPlayer bassline;
AudioBuffer basslineBuffer;

float basslineFrequency = 0;

float minHeight = 20;
float maxHeight = height - 20;
float dotHeight;


void setup()
{
  size (1024, 512);

  minim = new Minim (this);
  fft = new FFT(width, 44100);

  colorMode(HSB);

  basslineBuffer = trackSetup(bassline, basslineBuffer, "Audio and Data/test.mp3");
}
void draw()
{
  background (0);

  //idk what this does but we have to include it.
  fft.window (FFT.HAMMING);

  basslineFrequency = lerp (basslineFrequency, frequency(basslineBuffer), 0.5);

  rectMode(CENTER);

  rect (width / 2, height / 2, 20, basslineFrequency);


  text ("current loudest frequency: " + basslineFrequency, width / 2, height / 2);
}

//------------------------------------------------------------------------------
//This method will set up audio. To use it, use trackSetup() and in the brackets, 
//specify which AudioPlayer to use, its audio buffer(so we can analyise it), then it's location.
//it returns an audio buffer, meaning you can analyse from it.
//eg basslineBuffer = trackSetup(bassline, basslineBuffer, "bass.mp3");
//------------------------------------------------------------------------------
AudioBuffer trackSetup(AudioPlayer player_, AudioBuffer buffer_, String location)
{
  player_ = minim.loadFile (location, width);
  player_.play();
  buffer_ = player_.mix;

  return buffer_;
}

float frequency(AudioBuffer buffer_)
{
  fft.forward (buffer_); 

  int index = 0;
  float highestVolume = 0;

  for (int i = 0; i < fft.specSize(); i++)
  {
    float pitch = fft.getBand (i);

    if (pitch > highestVolume)
    {
      highestVolume = pitch; 
      index = i;
    }
  }

  return (fft.indexToFreq(index));
}
