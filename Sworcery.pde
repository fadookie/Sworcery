/**
 * Untitled Sworcery A/V Jam 2012 entry
 * by Eliot Lash
 */

import ddf.minim.*;

AudioPlayer player;
Minim minim;
Trigon trigon;

//Ways to draw a triangle, for Triangle#tri_type
static final char TRI_TYPE_CORNER = 1;
static final char TRI_TYPE_CENTER = 2;

//Types of Trigon pulses, for Trigon#triggerPulse
static final char PULSE_TYPE_PUSH = 1;

boolean DEBUG = false;
boolean tRotate = false;
boolean tScale = false;

float timeSongStarted;
float lastPulseTime = 0;
float pulseInterval = 3000;

void setup()
{
  size(800, 800);
  frameRate(30);
  noSmooth();
  strokeWeight(1);

  noFill();
  strokeCap(SQUARE);
  strokeJoin(MITER);

  minim = new Minim(this);
  
  // load a file, give the AudioPlayer buffers that are 1024 samples long
  // player = minim.loadFile("groove.mp3");
  
  // load a file, give the AudioPlayer buffers that are 2048 samples long
  player = minim.loadFile("UnknowableGeometry.mp3", 2048);
  // play the file
  //player.play();
  timeSongStarted = millis();
  
  Triangle centerTri = new Triangle(
    new PVector(width/2, height/2),
    100,
    radians(0)
  );
  centerTri.solid = true;
  centerTri.myColor = color(212, 222, 177);

  trigon = new Trigon(centerTri);
}

void draw()
{
  background(0);
  stroke(255);
  pushMatrix();
  translate(0, (height / 2) - 100);
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  /*
  for(int i = 0; i < player.left.size()-1; i++)
  {
    line(i, 50 + player.left.get(i)*50, i+1, 50 + player.left.get(i+1)*50);
    line(i, 150 + player.right.get(i)*50, i+1, 150 + player.right.get(i+1)*50);
  }
  */
  popMatrix();
  
  if (tScale) {
    trigon.scaleFactor += 0.01 * 2;
  }
  if (tRotate) {
    trigon.rotation += radians(1 * 2);
  }

  /*
  if ((millis() - lastPulseTime) > pulseInterval) {
    lastPulseTime = millis();
    trigon.triggerPulse(PULSE_TYPE_PUSH);
  }
  */

  trigon.update();
  trigon.draw();
}

void keyPressed() {
  if (CODED != key) {
    if ('S' == key) {
      saveFrame("screenshot.png");
      println("screenshot.png saved");
    } else if ('d' == key) {
      DEBUG = !DEBUG;
      println("DEBUG == " + DEBUG);
    } else if ('s' == key) {
      tScale = !tScale;
    } else if ('r' == key) {
      tRotate = !tRotate;
    } else if ('p' == key) {
      trigon.triggerPulse(PULSE_TYPE_PUSH);
    }
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  player.close();
  minim.stop();
  
  super.stop();
}
