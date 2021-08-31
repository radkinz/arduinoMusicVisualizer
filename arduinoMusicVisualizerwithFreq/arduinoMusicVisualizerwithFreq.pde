import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
Arduino arduino;
FFT fft;

int ledPin =  13;    // LED connected to digital pin 13
int ledPin2 =  12;  // LED connected to digital pin 12
int ledPin3 =  8;  // LED connected to digital pin 8 and etc....
int ledPin4 = 7;
int ledPin5 = 4;
int ledPin6 = 2;

void setup() {
  //load minim and audio needed
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  //load music
  song = minim.loadFile("AtR.mp3", 2048);
  song.play();
  
  //get fft
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //set up pins
  arduino.pinMode(ledPin, Arduino.OUTPUT);    
  arduino.pinMode(ledPin2, Arduino.OUTPUT);  
  arduino.pinMode(ledPin3, Arduino.OUTPUT);  
  arduino.pinMode(ledPin4, Arduino.OUTPUT); 
  arduino.pinMode(ledPin5, Arduino.OUTPUT); 
  arduino.pinMode(ledPin6, Arduino.OUTPUT); 
}

void draw() {
  background(0);
  fft.forward(song.mix);
  
  //calculate avg beat
  float bass = fft.calcAvg(0, 250);
  
  //create bass spectrum of certain lights only lighting up if bass hits certain freq
  if (bass > 20) {
    arduino.digitalWrite(ledPin, Arduino.HIGH);
  }
  if (bass > 40) {
    arduino.digitalWrite(ledPin2, Arduino.HIGH);
  }
  if (bass > 60) {
    arduino.digitalWrite(ledPin3, Arduino.HIGH);
  }
  if (bass > 80) {
    arduino.digitalWrite(ledPin4, Arduino.HIGH);
  }
  if (bass > 100) {
    arduino.digitalWrite(ledPin5, Arduino.HIGH);
  }
  if (bass > 120) {
    arduino.digitalWrite(ledPin6, Arduino.HIGH);
  } 
  arduino.digitalWrite(ledPin, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin2, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin3, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin4, Arduino.LOW);
  arduino.digitalWrite(ledPin5, Arduino.LOW);
  arduino.digitalWrite(ledPin6, Arduino.LOW);
}

void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}
